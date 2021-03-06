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

;*******************************************
; Put_image : COPY_PUT�i ��Q�i���� �a�� ��
; void copy_put( int x, int y, image_data image )
;*******************************************
proc copy_put  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... �a��Ϣ �a�a���a �A�a
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  mov dx, H_RES
  sub dx, bx      ; ax ... 320 - x_size

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@loop:
  mov ax, cx  ; push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add di, dx
  mov cx, ax  ; pop cx
  loop @@loop

 @@exit:
  ret
endp
global copy_put : proc


END
