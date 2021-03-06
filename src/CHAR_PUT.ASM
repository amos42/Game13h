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

;**********************************
;  ā����i ���e�a. (���w�e �A�A)
; void char_put( int x, int y, image_data image )
;**********************************
proc char_put  x:word, y:word, image:dword
  uses ds, es, si, di

  ; ah ... skip_color
  mov ah, [_attr_null_color]
  push ax

  ; es:di ... �a��Ϣ �A�a���a, ���a�U �A�a
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  lds si, [image] ; si ... ������ ���i�� ���b��

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  mov dx, H_RES
  sub dx, bx     ; dx ... 320 - x_size

  pop ax         ; ah ... skip color

  ; state :
  ;   si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... skip color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  cmp al, ah
  je @@skip
  stosb
  jmp @@next
 @@skip:
  inc di
 @@next:
  loop @@x_loop

  pop cx
  add di, dx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put : proc


;*******************************************
;  ā���᷁ �������e ���e�a. (���w�e �a�a)
; void char_put_cut( int x, int y, image_data image, int skip_x, int skip_y, int length_x, int length_y )
;*******************************************
proc char_put_cut  x:word, y:word, image:dword, skip_x, skip_y, length_x, length_y : word
  uses ds, es, si, di

  mov cl, [_attr_null_color]

  ; es ... �a��Ϣ �a�a���a �a�a
  set_page es, [_page_number]

  ; di ... �a��Ϣ ���a�u
  mov ax, [y]
  add ax, [skip_y]
  calc_addr di, [x], ax
  add di, [skip_x]

  lds si, [image]    ; si ... ������ ���i�� ���b��

  mov bx, [si]
  add si, 4          ; bx ... �������� x �a��

  ; si�a�� �|�� �������e�q ���a.
  mov ax, [skip_y]
  mul bx
  add ax, [skip_x]
  add si, ax

  mov ah, cl           ; ah ... skip color

  mov dx, H_RES
  sub dx, [length_x]   ; dx ... 320 - length_x

  sub bx, [length_x]   ; bx ... size_x - length_x

  mov cx, [length_y]   ; ���i y�� �a���i ��� �e�a.

  ; state :
  ;   si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... skip_color
  ;   bx ... image carage
  ;   cx ... length_y
  ;   dx ... screen carage

  cld

 @@y_loop:
  push cx
  mov cx, [length_x]

 @@x_loop:
  lodsb
  je @@skip
  stosb
  jmp @@next
 @@skip:
  inc di
 @@next:
  loop @@x_loop

  add di, dx
  add si, bx

  pop cx
  loop @@y_loop

  ret
endp
global char_put_cut : proc


END
