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

;******************************
;  �a���a �� �a�b�w�i �a���a.
; void bar_shade( int start_x, int start_y, int end_x, int end_y, char shade )
;******************************
proc bar_shade  start_x:word, start_y:word, end_x:word, end_y:word, shade:byte
  uses ds, es, si, di

  ; es:di = ds:si ... �a��Ϣ �A�a���a, ���a�U
  set_page ax, [_page_number]
  mov ds, ax
  mov es, ax
  calc_addr si, [start_x], [start_y]
  mov di, si

  mov bx, [end_x]
  sub bx, [start_x]
  inc bx          ; bx ... �a�b�w�� x �a��
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx          ; cx ... �a�b�w�� y �a���i �a�a

  mov dx, H_RES
  sub dx, bx      ; dx ... 320 - x_size
  mov ah, [shade] ; ah ... shade

  ; state :
  ;   es:di ... ���e�w�� �a�b�w ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  add al, ah
  stosb
  loop @@x_loop

  add di, dx
  mov si, di
  pop cx
  loop @@y_loop

  ret
endp
global bar_shade : proc


END
