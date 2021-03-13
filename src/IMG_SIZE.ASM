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

;*****************************************
;  »¡¸÷ ·¡£¡»¡· X, Y· Ça‹¡Ÿi ´i´a…”a.
; word image_size( image_data image )
;*****************************************
proc image_size image:dword
  uses es

  les bx, [image]
  mov ax, [es:bx]
  mov dx, [es:bx+2]

  mul dx
  add ax, 4

  ret
endp
global image_size : proc


;*****************************************
;  »¡¸÷ ·¡£¡»¡· X, Y· Ça‹¡Ÿi ´i´a…”a.
; void image_size_xy( image_data image, word *x, word *y )
;*****************************************
proc image_size_xy image:dword, x:dword, y:dword
  uses es

  les bx, [image]
  mov cx, [es:bx]
  mov dx, [es:bx+2]

  les bx, [x]
  mov [es:bx], cx

  les bx, [y]
  mov [es:bx], dx

  ret
endp
global image_size_xy : proc


END
