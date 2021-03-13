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

  voc_data    dd  ?
  voc_size    dw  ?
  voc_ptr     dw  ?

  old_speaker_vect procedure <>


DATASEG


CODESEG

;*********************************************
;  CMOSµA •A·¡ÈáŸi °á ý“e”a.(¯aÏ¡Äá· ‰w¶)
; * Breaken;
;   al
;*********************************************
macro write_cmos  index, data
  mov al, &index&
  out 70h, al
  mov al, &data&
  out 71h, al
endm


;***************************************
;  ·¥ÈáœóËaŸi ¹AˆáÐe”a.(¯aÏ¡Äá· ‰w¶)
; void clear_speaker_vect()
;***************************************
proc clear_speaker_vect
  _if_zero [_voice_flag], @@exit

  write_cmos 0Bh, 02h
  write_cmos 0Ah, 0A6h

  in al, 0A1h
  or al, 00000001b
  out 0A1h, al

  push ds
  lds dx, [dword old_speaker_vect]
  mov ax, 2570h
  int 21h
  pop ds

  mov [_voice_flag], FALSE

 @@exit:
  ret
endp
public clear_speaker_vect


;*******************************************
;  ¬¡¶… CMOS·¥ÈáœóËa Ð…—i(¯aÏ¡Äá· ‰w¶)
;*******************************************
proc new_speaker_vect
  cli
  push ds es ax bx dx

  mov ax, DGROUP
  mov ds, ax

  mov ax, [voc_ptr]
  inc [voc_ptr]
  les bx, [voc_data]
  add bx, ax
  in al, 61h
  test [byte es:bx], 10000000b
  je @@low
 @@high:
  or al, 00000010b
  jmp @@next
 @@low:
  and al, 11111100b
 @@next:
  out 61h, al

  mov ax, [voc_ptr]
  cmp ax, [voc_size]
  jb @@skip
  call clear_speaker_vect   ; Braken ax, ds, dx

 @@skip:
  mov al, 0Ch
  out 70h, al
  in al, 71h

  mov al, 20h
  out 0A0h, al
  out 20h, al

  pop dx bx ax es ds
  iret
endp


;***********************************
;  ·q¬÷·i Â‰bÐe”a.(¯aÏ¡Äá· ‰w¶)
; void output_speaker( voice_data data )
;***********************************
proc output_speaker  data:voice_data
  _if_zero [data.length], @@exit

  _if_zero [_voice_flag], @@process
    call clear_speaker_vect

 @@process:
  mov ax, [data.length]
  mov [voc_size], ax
  mov ax, [word high data.ptr]
  mov [word high voc_data], ax
  mov ax, [word low  data.ptr]
  mov [word low  voc_data], ax
  mov [voc_ptr], 0

  push ds es
  mov ax, 3570h
  int 21h
  mov [old_speaker_vect.reg_ip], bx
  mov [old_speaker_vect.reg_cs], es

  mov ax, seg new_speaker_vect
  mov ds, ax
  mov dx, offset new_speaker_vect
  mov ax, 2570h
  int 21h
  pop es ds

  in al, 0A1h
  and al, 0FEh
  out 0A1h, al
  write_cmos 0Ah, 0A3h
  write_cmos 0Bh, 42h

  mov [_voice_flag], TRUE

 @@exit:
  ret
endp
public output_speaker


END
