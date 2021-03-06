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

;**********************************
;  ������ �e���e �������i ��e�a.
; void image_flip_hiriz( image_data source_image, image_data *target_image )
;**********************************
proc image_flip_horiz  source_image:dword, target_image:dword
  uses ds, es, si, di

  ; ds:si ... ������ ���i�� ���b��
  lds si, [source_image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  push ds bx cx
  mov ax, DGROUP
  mov ds, ax

  mov ax, bx
  mul cx
  add ax, 4   ; ax = size_x * size_y + 4
  call farmalloc, ax, dx
  les bx, [target_image]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax

  pop cx bx ds
  mov [es:di], bx
  mov [es:di+2], cx

  add di, 3    ; because move_ptr
  add di, bx   ; move point left end

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... �e��I ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size

  cld

 @@y_loop:
  mov dx, cx        ; push cx
  mov cx, bx

 @@x_loop:
  lodsb
  mov [es:di], al
  dec di
  loop @@x_loop

  add di, bx
  add di, bx
  mov cx, dx        ; pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global image_flip_horiz : proc


;*******************************************
;  �w�a�� �e���e �������i ��e�a.
; void image_flip_vert( image_data source_image, image_data *target_image )
;*******************************************
proc image_flip_vert  source_image:dword, target_image:dword
  uses ds, es, si, di

  ; ds:si ... ������ ���i�� ���b��
  lds si, [source_image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  push ds bx cx
  mov ax, DGROUP
  mov ds, ax

  mov ax, bx
  mul cx
  add ax, 4   ; ax = size_x * size_y + 4
  push ax
  call farmalloc, ax, dx
  les bx, [target_image]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax
  pop dx

  pop cx bx ds
  mov [es:di], bx
  mov [es:di+2], cx

  add di, dx
  sub di, bx

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... �e��I ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size

  cld

 @@loop:
  mov dx, cx  ; push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  movsb
 @@skip:
  jcxz @@no_put
  rep movsw
 @@no_put:

  sub di, bx
  sub di, bx
  mov cx, dx  ; pop cx
  loop @@loop

 @@exit:
  ret
endp
global image_flip_vert : proc


;**************************************
;  �w�a������ �e���e �������i ��e�a.
; void image_flip_both( image_data source_image, image_data *target_image )
;**************************************
proc image_flip_both  source_image:dword, target_image:dword
  uses ds, es, si, di

  ; ds:si ... ������ ���i�� ���b��
  lds si, [source_image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  push ds bx cx
  mov ax, DGROUP
  mov ds, ax

  mov ax, bx
  mul cx
  push ax
  add ax, 4   ; ax = size_x * size_y + 4
  call farmalloc, ax, dx
  les bx, [target_image]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax
  pop cx

  pop dx bx ds
  mov [es:di], bx
  mov [es:di+2], dx

  add di, 3
  add di, cx   ; move point left end

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... �e��I ������ ���b����
  ;   cx ... x_size * y_size

  cld

 @@loop:
  lodsb
  mov [es:di], al
  dec di
  loop @@loop

 @@exit:
  ret
endp
global image_flip_both : proc


END
