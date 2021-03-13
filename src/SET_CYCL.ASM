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


UDATASEG

  start_cycle_color  db ?
  end_cycle_color    db ?
  s_clock            dw ?
  delay_clock        dw ?
  old_cycle_vect procedure <>


DATASEG

  _use_cycle_palette  dw FALSE


CODESEG

;***************************
;  ¬¡¶… cycle ·¥ÈáœóËa
;***************************
proc new_cycle_vect
  cli
  push ds es si di ax bx cx dx

  mov ax, DGROUP
  mov ds, ax

  mov ax, [delay_clock]
  cmp [s_clock], ax
  jbe @@skip

  mov dx, 3C8h
  in al, dx
  mov si, ax

  mov [s_clock], 0
  mov al, [start_cycle_color]
  mov bl, [end_cycle_color]
  call cycle_palette, ax, bx

  mov ax, si
  mov dx, 3C8h
  out dx, al
  jmp @@exit

 @@skip:
  inc [s_clock]

 @@exit:
  pushf
  call [dword old_cycle_vect]

  pop dx cx bx ax di si es ds
  iret
endp


;*************************************
;  ¬¡¶… cycle ·¥ÈáœóÈáŸi ¬é¸÷Ðe”a.
; void set_cycle( byte start_color, byte end_color, word delay_time )
;*************************************
proc set_cycle  start_color:byte, end_color:byte, delay_time:word
  uses si, di

  xor ah, ah
  mov al, [start_color]
  mov si, ax
  mov al, [end_color]
  mov di, ax
  _if si equal di
    jmp @@exit
  _endif

  mov ax, si
  mov [start_cycle_color], al
  mov ax, di
  mov [end_cycle_color], al
  mov ax, [delay_time]
  mov [delay_clock], ax

  push ds es
  mov ax, 351Ch
  int 21h
  mov [old_cycle_vect.reg_ip], bx
  mov [old_cycle_vect.reg_cs], es

  mov ax, seg new_cycle_vect
  mov ds, ax
  mov dx, offset new_cycle_vect
  mov ax, 251Ch
  int 21h
  pop es ds

  mov [_use_cycle_palette], TRUE

 @@exit:
  ret
endp
global set_cycle : proc


;**************************************
;  cycle ·¥ÈáœóËaŸi ¶¥œ”¡ –a•©Ÿ¥”a.
; void reset_cycle(void)
;**************************************
proc reset_cycle
  _if_zero [_use_cycle_palette], @@exit

  push ds
  mov ax, 251Ch
  lds dx, [dword old_cycle_vect]
  int 21h
  pop ds

  mov [_use_cycle_palette], FALSE

 @@exit:
  ret
endp
global reset_cycle : proc


END
