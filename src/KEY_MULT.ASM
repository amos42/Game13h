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

  _key           multi_key_data <>
  old_key_vect   procedure <>


DATASEG

  _use_multi_key  dw  FALSE


CODESEG

;*************************
;  ¬¡¶… Ç¡¥¡—a ·¥ÈáœóËa
;*************************
proc new_key_vect
  cli
  push ds ax bx

  mov ax, DGROUP
  mov ds, ax

  xor ah, ah
  mov bx, offset _key.scan
  in al, 60h
  test al, 10000000b
  jnz @@key_release

  mov [_key.last], al
  add bx, ax
  mov al, [bx]
  test al, al
  jnz @@new_key_exit
  mov [byte bx], TRUE
  inc [_key.press]
  jmp @@new_key_exit

 @@key_release:
  and al, 01111111b
  add bx, ax
  mov al, [bx]
  test al, al
  jz @@new_key_exit
  mov [byte bx], FALSE
  dec [_key.press]

 @@new_key_exit:
  mov al, 20h
  out 20h, al

  pop bx ax ds
  iret
endp


;*************************************
;  ¬¡¶… Ç¡¥¡—a ·¥ÈáœóËaŸi ­AËaÐe”a.
; void set_multi_key(void)
;*************************************
proc set_multi_key
  uses ds, es, di

  _if_not_zero [_use_multi_key], @@exit
  mov [_use_multi_key], TRUE

  mov [_key.press], 0

  mov ax, DGROUP
  mov es, ax
  mov di, offset _key.scan
  mov cx, 128
  xor al, al
  rep stosb

  mov ax, 3509h
  int 21h
  mov [old_key_vect.reg_ip], bx
  mov [old_key_vect.reg_cs], es

  mov ax, seg new_key_vect
  mov ds, ax
  mov dx, offset new_key_vect
  mov ax, 2509h
  int 21h

 @@exit:
  ret
endp
global set_multi_key : proc


;******************************
;   éË¡Ç¡ ·¥ÈáœóËaŸi ¹AˆáÐe”a.
; void reset_multi_key(void)
;******************************
proc reset_multi_key
  uses ds

  _if_zero [_use_multi_key], @@exit
  mov [_use_multi_key], FALSE

  mov ax, 2509h
  lds dx, [dword old_key_vect]
  int 21h

 @@exit:
  ret
endp
global reset_multi_key : proc


END
