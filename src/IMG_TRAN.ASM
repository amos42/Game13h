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

  extrn farmalloc         : proc


UDATASEG


DATASEG


CODESEG

;*********************
; �������i ���a�e�a.
; void image_translate( image_data source_image, image_data *target_image, char tran )
;*********************
proc image_translate  source_image:dword, target_image:dword, tran:byte
  uses ds, es, si, di

  ; ds:si ... ������ ���i�� ���b��
  lds si, [source_image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit

  push ds
  mov ax, DGROUP
  mov ds, ax

  mov ax, bx
  mul cx
  add ax, 4   ; ax = size_x * size_y + 4
  push ax
  call farmalloc, ax, dx
  pop cx
  les bx, [target_image]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax

  mov dh, [_attr_null_color]
  pop ds
  mov dl, [tran]
  movsw
  movsw
  sub cx, 4

 @@loop:
  lodsb
  cmp al, dh
  je @@skip
  add al, dl
 @@skip:
  stosb
  loop @@loop

 @@exit:
  ret
endp
global image_translate : proc


END
