;*****************************************
;
;     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
;                       Ver 4.2
;
;                 ¹A¸b¸a:
;                        º ‰w £¥
;
;  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
; ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.
;
;*****************************************
IDEAL
include "game13h.inc"

  SB_RESET         equ 06h
  DMA_MASK         equ 0Ah
  DMA_MODE         equ 0Bh
  BYTE_PTR         equ 0Ch
  READ_CMD         equ 48h
  SET_CMD          equ 00h
  RESET_CMD        equ 04h
  DMA_MASK_SET     equ 04h
  DMA_MASK_RESET   equ 00h
  TIME_CONSTANT    equ 40h
  DMA_8_BIT_DAC    equ 14h
  SPEAKER_ON       equ 0D1h
  SPEAKER_OFF      equ 0D3h
  DSP_WRITE_STATUS equ 0Ch
  DSP_DATA_AVAIL   equ 0Eh
  HALT_DMA         equ 0D0h
  CONTINUE_DMA     equ 0D4h


UDATASEG

  old_irq_vect procedure <>


DATASEG

  _sb  sb_state  < 220h, 7, 1 >

  page_table      db 87h, 83h, 81h, 82h


CODESEG

;******************************************
;  DACµA •A·¡ÈáŸi °á ý“e”a.(¬a§i· ‰w¶)
; braken : dx, al
;******************************************
macro write_dac  out_data
  local wait_vect

  mov dx, [_sb.io_addr]

  add dx, DSP_WRITE_STATUS
 wait_vect:
  in al, dx
  test al, 10000000b
  jnz wait_vect

  mov al, &out_data&
  out dx, al
endm


;****************************************
;  ¬¡¶… IRQ·¥ÈáœóËa Ð…—i(¬a§i· ‰w¶)
;****************************************
proc new_irq_vect
  cli
  push ds ax

  mov ax, DGROUP
  mov ds, ax

  mov [_voice_flag], FALSE

  in al, DSP_DATA_AVAIL

  mov al, 20h
  out 20h, al

  pop ax ds
  iret
endp


;*************************
; ¬a¶…—a §iœ¯aËa Á¡‹¡ÑÁ
; void init_sb()
;*************************
proc init_sb
  mov al, 1
  mov dx, [_sb.io_addr]
  add dx, SB_RESET
  out dx, al

  in al, dx
  in al, dx
  in al, dx
  in al, dx

  xor al, al
  out dx, al
  add dx, 4
  mov cx, 100

 @@find_sb:
  in al, dx
  cmp al, 0AAh      ; AAh is ID of Sound Blaster
  je @@sb_card_find
  loop @@find_sb

  mov ax, 1
  ret

 @@sb_card_find:
  push es
  mov al, [_sb.irq]
  add al, 08h
  mov ah, 35h
  int 21h
  mov [old_irq_vect.reg_ip], bx
  mov [old_irq_vect.reg_cs], es
  pop es

  push ds
  mov bx, seg new_irq_vect
  mov ds, bx
  mov dx, offset new_irq_vect
  mov ah, 25h
  int 21h
  pop ds

  in al, 21h
  mov cl, [_sb.irq]
  mov ah, 1
  shl ah, cl
  not ah
  and al, ah
  out 21h, al

  xor ax, ax
  ret
endp
public init_sb


;***************************
; ¬‘ÏiŸ· ºÌa®Ÿi ¬é¸÷Ðe”a.
; void sample_rate( word rate )
;***************************
proc sample_rate  rate : word
  ; dx:ax <= 1000000
  mov dx, 1000000 shr 16
  mov ax, 1000000 and 0FFFFh
  div [rate]
  xor bl, bl
  sub bl, al

  write_dac TIME_CONSTANT
  write_dac bl

  ret
endp


;*************************
;  ¯aÏ¡ÄáŸi Åaˆáa e”a.
; void speaker_on(), void speaker_off()
;*************************
proc speaker_on
  write_dac SPEAKER_ON
  ret
endp

proc speaker_off
  write_dac SPEAKER_OFF
  ret
endp


;******************************
; ·q¬÷·i ¸÷»¡Ðaˆáa ‰­¢Ðe”a.
; void stop_voice()
;******************************
proc stop_voice
  write_dac HALT_DMA
  ret
endp


;****************************************
; IRQŸi ¶¥œ”¡ –A•©Ÿ¥”a.(¬a§i· ‰w¶)
; voic sb_clear_irq_vect()
;****************************************
proc sb_clear_irq_vect
  _if_not_zero [_voice_flag], @@next

  write_dac HALT_DMA
  mov [_voice_flag], FALSE

 @@next:
  write_dac SPEAKER_OFF

  push ds
  mov al, [_sb.irq]
  add al, 08h
  lds dx, [dword old_irq_vect]
  mov ah, 25h
  int 21h
  pop ds

  in al, 21h
  mov cl, [_sb.irq]
  mov ah, 1
  shl ah, cl
  or al, ah
  out 21h, al

  ret
endp
public sb_clear_irq_vect


;*********************************
;  ·q¬÷·i Â‰bÐe”a.(¬a§i· ‰w¶)
; void sb_output_voice( voide_data data )
;*********************************
proc sb_output_dma  data:voice_data
  _if_not_zero [data.length], @@next
  jmp @@exit

 @@next:
  _if_zero [_voice_flag], @@no_playing_now
  write_dac HALT_DMA

 @@no_playing_now:

  ; Byte Í¡·¥Èá Flip/Flop Ÿ¡­U
  xor al, al
  out BYTE_PTR, al

  ; DMAÁAé ¬é¸÷
  xor bh, bh
  mov bl, [_sb.dma_channel]

  ; === Reset DMA ===
  mov al, bl
  add al, RESET_CMD
  out DMA_MASK, al

  ; === Setup DMA ===

  ; Â‰b ´á—aA¯a· ÍA·¡»¡ ¬é¸÷
  xor dh, dh
  mov dl, [page_table + bx]
  mov ax, [word high data.linear_addr]  ; al ... DMA Page
  out dx, al

  ; Â‰b DMA Í¡Ëa º­¡ ¬é¸÷
  mov dl, bl
  shl dx, 1

  ; Â‰b ´á—aA¯aŸi ¬wÐa¶á º­¡ ¬é¸÷
  mov ax, [word low data.linear_addr]    ; cx ... DMA Address
  out dx, al
  mov al, ah
  out dx, al

  ; DMA 8§¡Ëa Äa¶…Èá· ¬wÐa¶á ¤a·¡ËaŸi ­AËa
  inc dx
  mov cx, [data.length]
  mov al, cl
  out dx, al
  mov al, ch
  out dx, al

  ; DMA Read ¡¡—a¡ ­AËa
  mov al, READ_CMD
  add al, bl              ; al = Command + Channel
  out DMA_MODE, al

  mov al, bl + SET_CMD    ; al = Command + Channel
  out DMA_MASK, al

  sti

  ; Setup Soundblaster for transfer
  mov dx, [_sb.io_addr]
  add dx, DSP_DATA_AVAIL
  in al, dx

  write_dac DMA_8_BIT_DAC
  write_dac cl
  write_dac ch

  mov [_voice_flag], TRUE

 @@exit:
  ret
endp
public sb_output_dma


END
