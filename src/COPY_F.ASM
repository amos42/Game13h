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
;  ������ �e��Ё�� ���e�a.(COPY_PUT)
; void copy_put_flip_hiriz( int x, int y, image_data image )
;*******************************************
proc copy_put_flip_horiz  x:word, y:word, image:dword
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
  add dx, bx      ; ax ... 320 + x_size

  dec di
  add di, bx   ; move point left end

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 + x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  mov [es:di], al
  dec di
  loop @@x_loop

  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global copy_put_flip_horiz : proc


;*******************************************
;  �w�a�� �e��Ё�� ���e�a.(COPY_PUT)
; void copy_put_flip_vert( int x, int y, image_data image )
;*******************************************
proc copy_put_flip_vert  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... �a��Ϣ �a�a���a �A�a
  set_page es, [_page_number]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  mov ax, [y]
  add ax, cx
  dec ax
  calc_addr di, [x], ax

  mov dx, H_RES
  add dx, bx      ; dx ... 320 + x_size

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 + x_size)

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
  sub di, dx
  mov cx, ax  ; pop cx
  loop @@loop

 @@exit:
  ret
endp
global copy_put_flip_vert : proc


;*******************************************
;  �w�a������ �e��Ё�� ���e�a.(COPY_PUT)
; void copy_put_flip_both( int x, int y, image_data image )
;*******************************************
proc copy_put_flip_both  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... �a��Ϣ �a�a���a �A�a
  set_page es, [_page_number]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  mov ax, [y]
  add ax, cx
  dec ax
  calc_addr di, [x], ax

  mov dx, H_RES
  sub dx, bx      ; ax ... 320 - x_size

  dec di
  add di, bx   ; move point left end

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  mov [es:di], al
  dec di
  loop @@x_loop

  sub di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global copy_put_flip_both : proc


END
