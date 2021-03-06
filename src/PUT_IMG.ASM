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

;****************************************
;  ����A ��w�E �������i ���e�A �����a.
; void put_image( int x, int y, image_data image, char option )
;****************************************
proc put_image  x:word, y:word, image:dword, option:byte
  uses ds, es, si, di

  ; es:di ... �a��Ϣ �A�a���a, ���a�U �A�a
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]   ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2] ; cx ... �������� y �a��
  jcxz @@exit
  add si, 4

  mov ah, [option]
  mov dx, H_RES
  sub dx, bx        ; dx ... H_RES - X size

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... Logical Option
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

 @@y_loop:
  push cx

  mov cx, bx
 @@x_loop:
  lodsb

  cmp ah, 'c'
  jne @@test_or
  mov [es:di], al
  jmp @@logic_exit
 @@test_or:
  cmp ah, 'o'
  jne @@test_and
  or [es:di], al
  jmp @@logic_exit
 @@test_and:
  cmp ah, 'a'
  jne @@test_xor
  and [es:di], al
  jmp @@logic_exit
 @@test_xor:
  cmp ah, 'x'
  jne @@logic_exit
  xor [es:di], al
 @@logic_exit:
  inc di
  loop @@x_loop

  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global put_image : proc


END
