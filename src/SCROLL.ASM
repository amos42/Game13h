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

;*****************************
;  ���e�i �ᝡ �a�a�� ��ǥ�a.
; void scroll_up( int start_x, int start_y, int end_x, int end_y, word step )
;*****************************
proc scroll_up  start_x, start_y, end_x, end_y, step : word
  uses ds, es, si, di

  ; ds, es �a���a��a �a��Ϣ �a�a���a�i �a�a�e�a
  set_page ax, [_page_number]
  mov ds, ax
  mov es, ax
  calc_addr di, [start_x], [start_y]

  ; si = di + step * H_RES
  mul_320 si, [step]
  add si, di

  ; ax = x2 - x1 + 1
  mov ax, [end_x]
  sub ax, [start_x]
  inc ax

  ; cx = y2 - y1 + 1 - step
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx
  sub cx, [step]

  mov dx, H_RES
  sub dx, ax
  cld

 @@loop:
  mov bx, cx  ; push cx
  mov cx, ax
  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@skip2
 @@skip:
  rep movsw
 @@skip2:
  mov cx, bx  ; pop cx
  add di, dx
  add si, dx
  loop @@loop

  ret
endp
global scroll_up : proc


;********************************
;  ���e�i �a���� �a�a�� ��ǥ�a.
; void scroll_down( int start_x, int start_y, int end_x, int end_y, word step )
;********************************
proc scroll_down  start_x, start_y, end_x, end_y, step : word
  uses ds, es, si, di

  ; ds, es �a���a��a �a��Ϣ �a�a���a�i �a�a�e�a
  set_page ax, [_page_number]
  mov ds, ax
  mov es, ax
  calc_addr di, [end_x], [end_y]

  ; si = di - step * H_RES
  mul_320 bx, [step]
  mov si, di
  sub si, bx

  ; ax = x2 - x1 + 1
  mov ax, [end_x]
  sub ax, [start_x]
  inc ax

  ; cx = y2 - y1 + 1 - step
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx
  sub cx, [step]

  mov dx, H_RES
  sub dx, ax
  std

 @@loop:
  mov bx, cx  ; push cx
  mov cx, ax
  rep movsb
  mov cx, bx  ; pop cx
  sub di, dx
  sub si, dx
  loop @@loop

  ret
endp
global scroll_down : proc


;**********************************
;  ���e�i �e���a�� �a�a�� ��ǥ�a.
; void scroll_left( int start_x, int start_y, int end_x, int end_y, word step )
;**********************************
proc scroll_left  start_x, start_y, end_x, end_y, step : word
  uses ds, es, si, di

  ; ds, es �a���a��a �a��Ϣ �a�a���a�i �a�a�e�a
  set_page ax, [_page_number]
  mov ds, ax
  mov es, ax
  calc_addr di, [start_x], [start_y]

  ; si = di + step
  mov si, di
  add si, [step]

  ; ax = x2 - x1 + 1 - step
  mov ax, [end_x]
  sub ax, [start_x]
  inc ax
  sub ax, [step]

  ; cx = y2 - y1 + 1
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx

  mov dx, H_RES
  sub dx, ax
  cld

 @@loop:
  mov bx, cx  ; push cx
  mov cx, ax
  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@skip2
 @@skip:
  rep movsw
 @@skip2:
  mov cx, bx  ; pop cx
  add di, dx
  add si, dx
  loop @@loop

  ret
endp
global scroll_left : proc


;************************************
;  ���e�i ���e���a�� �a�a�� ��ǥ�a.
; void scroll_right( int start_x, int start_y, int end_x, int end_y, word step )
;************************************
proc scroll_right  start_x, start_y, end_x, end_y, step : word
  uses ds, es, si, di

  ; ds, es �a���a��a �a��Ϣ �a�a���a�i �a�a�e�a
  set_page ax, [_page_number]
  mov ds, ax
  mov es, ax
  calc_addr di, [end_x], [end_y]

  ; si = di - step
  mov si, di
  sub si, [step]

  ; ax = x2 - x1 + 1 - step
  mov ax, [end_x]
  sub ax, [start_x]
  inc ax
  sub ax, [step]

  ; cx = y2 - y1 + 1
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx

  mov dx, H_RES
  sub dx, ax
  std

 @@loop:
  mov bx, cx  ; push cx
  mov cx, ax
  rep movsb
  mov cx, bx  ; pop cx
  sub di, dx
  sub si, dx
  loop @@loop

  ret
endp
global scroll_right : proc


END
