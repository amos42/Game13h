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

;***************************
;  ���� �e �a�b�w�i �a���a.
; void bar( int start_x, int start_y, int end_x, int end_y, byte color )
;***************************
proc bar  start_x:word, start_y:word, end_x:word, end_y:word, color:byte
  uses es, si, di

  ; es:di ... �a��Ϣ �A�a���a, ���a�U
  set_page es, [_page_number]
  calc_addr di, [start_x], [start_y]

  mov bx, [end_x]
  sub bx, [start_x]
  inc bx                  ; bx ... �a�b�w�� x �a��
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx                  ; cx ... �a�b�w�� y �a���i �a�a

  mov dx, H_RES
  sub dx, bx    ; dx ... 320 - x_size

  ; ah, al ... color
  mov al, [color]
  mov ah, al

  ; state :
  ;   es:di ... ���e�w�� �a�b�w ���b����
  ;   ah,al ... color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@loop:
  mov si, cx  ; push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  stosb
 @@skip:
  jcxz @@no_put
  rep stosw
 @@no_put:

  add di, dx
  mov cx, si  ; pop cx
  loop @@loop

  ret
endp
global bar : proc


END
