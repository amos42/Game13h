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

;*************************************************
; �a�E�� ���i ���w��ǡ�� �g�� �������i ���e�a.
; void stencil_put( int x, int y, image_data image, byte stencil )
;*************************************************
proc stencil_put  x:word, y:word, image:dword, stencil:byte
  local skip_color:byte
  uses ds, es, si, di

  mov al, [_attr_null_color]
  mov [skip_color], al

  ; es:di ... �a��Ϣ �a�a���a �a�a
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �a�a
  jcxz @@exit
  add si, 4

  mov ax, H_RES
  sub ax, bx         ; ax ... 320 - x_size

  mov dh, [stencil]  ; dh ... �a�e�� ���

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ax ... carage (320 - x_size)
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dh ... stencil color

 @@y_loop:
  push cx

  mov cx, bx
 @@x_loop:
  cmp dh, [es:di]
  je @@skip
  mov dl, [ds:si]
  cmp dl, [skip_color]
  je @@skip
  mov [es:di], dl
 @@skip:
  inc si
  inc di
  loop @@x_loop

  pop cx
  add di, ax
  loop @@y_loop

 @@exit:
  ret
endp
global stencil_put : proc


;*************************************************************
;  �a�e�� ���a Ё�w�a�e ���e�i �a���e�� �������i ���e�a.
; void stencil_put_opp( int x, int y, image_data image, byte opp_stencil )
;*************************************************************
proc stencil_put_opp  x:word, y:word, image:dword, opp_stencil:byte
  local skip_color:byte
  uses ds, es, si, di

  mov al, [_attr_null_color]
  mov [skip_color], al

  ; es:di ... �a��Ϣ �a�a���a �a�a
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [si+2]  ; cx ... �������� y �a���i �a�a
  jcxz @@exit
  add si, 4

  mov ax, H_RES
  sub ax, bx         ; ax ... 320 - x_size

  mov dh, [opp_stencil]  ; dh ... �a�e�� ���

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ax ... carage (320 - x_size)
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dh ... oppsition stencil color

 @@y_loop:
  push cx

  mov cx, bx
 @@x_loop:
  cmp dh, [es:di]
  jne @@skip
  mov dl, [ds:si]
  cmp dl, [skip_color]
  je @@skip
  mov [es:di], dl
 @@skip:
  inc si
  inc di
  loop @@x_loop

  pop cx
  add di, ax
  loop @@y_loop

 @@exit:
  ret
endp
global stencil_put_opp : proc


END
