;*****************************************
;
;     ���a 13h�w �A�� �b�� �a���a�១
;                       Ver 4.2
;
;                 �A�b�a:
;                        �� �w ��
;
;  �A�� �b���i ��Ё �e�e �a���a�១����
; ���a 13h (320x200, 256) ��w���a.
;
;*****************************************
IDEAL
include "game13h.inc"


UDATASEG


DATASEG


CODESEG

;*****************************************
;  ���� �������� X, Y�� �a���i �i�a���a.
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
;  ���� �������� X, Y�� �a���i �i�a���a.
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
