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


DATASEG


CODESEG

;********************************
;  ºa·¡¯aË¢· ¶áÃ¡Ÿi ·³b¤h“e”a.
; void get_joy_stick( int *x, int *y )
;********************************
proc get_joy_stick  x:dword, y:dword
  uses es

  mov dx, 201h  ; ºa·¡¯aË¢ Í¡Ëa ˆt

  mov cx, 1000
 @@ready_horiz:
  in al, dx
  test al, 00000001b
  loopnz @@ready_horiz
  out dx, al

  mov cx, 1000
 @@loop_horiz:
  in al, dx
  test al, 00000001b
  loopnz @@loop_horiz

  sub cx, 1000
  neg cx
  les bx, [x]
  mov [es:bx], cx

  mov cx, 1000
 @@ready_vert:
  in al, dx
  test al, 00000010b
  loopnz @@ready_vert
  out dx, al

  mov cx, 1000
 @@loop_vert:
  in al, dx
  test al, 00000010b
  loopnz @@loop_vert

  sub cx, 1000
  neg cx
  les bx, [y]
  mov [es:bx], cx

  ret
endp
global get_joy_stick : proc


;*********************************
;  ºa·¡¯aË¢· ¤áËe¬wÈŸi ´è“e”a.
; int get_joy_button(void)
;*********************************
proc get_joy_button
  mov dx, 201h
  in al, dx

  not al
  and al, 00110000b
  shr al, 4
  xor ah, ah

  ret
endp
global get_joy_button : proc


END
