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
;  char_put�� y�i��Ϸ ���
; void char_put_clip_y( int x, int y, image_data image )
;***************************
proc char_put_clip_y  x:word, y:word, image:dword
  local temp_color:byte, temp:word
  uses ds, es, si, di

  mov ah, [_attr_null_color]   ; ah ... skip_color
  mov [temp_color], ah

  set_page es, [_page_number]  ; es ... �a��Ϣ �A�a���a �A�a
  lds si, [image]              ; bx ... ������ ���i�� ���b��

  mov bx, [ds:si]     ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  ; clipping y
  mov ax, [y]
  call _clipping_y
  jcxz @@exit

  calc_addr di, [x], ax  ; si ... ������ ���a�u

  mov dx, H_RES
  sub dx, bx     ; dx ... 320 - x_size

  mov ah, [temp_color]

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... skip_color
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

  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_clip_y : proc


;***************************
;  char_put�� x�i��Ϸ ���
; void char_put_clip_x( int x, int y, image_data image )
;***************************
proc char_put_clip_x  x:word, y:word, image:dword
  local image_carage:word, temp_color:byte
  uses ds, es, si, di

  mov ah, [_attr_null_color]   ; ah ... skip_color
  mov [temp_color], ah

  set_page es, [_page_number]  ; es ... �a��Ϣ �A�a���a �A�a
  lds si, [image]              ; bx ... ������ ���i�� ���b��

  mov bx, [ds:si]     ; bx ... �������� x �a��
  mov cx, [ds:si+2]   ; cx ... �������� y �a���i �A�a
  add si, 4
  mov [image_carage], bx

  calc_addr di, [x], [y]  ; di ... �a��Ϣ ���a�u

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  mov dx, H_RES
  sub dx, bx         ; dx ... 320 - x_size

  sub [image_carage], bx   ; ������ ���i�� ā�����t
  mov ah, [temp_color]

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... skip color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... screen carage (320 - x_size)

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

  add si, [image_carage]
  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_clip_x : proc


;***************************
;  char_put�� x�i��Ϸ ���
; void char_put_clip( int x, int y, image_data image )
;***************************
proc char_put_clip  x:word, y:word, image:dword
  local image_carage:word, temp_color:byte
  uses ds, es, si, di

  mov ah, [_attr_null_color]   ; ah ... skip_color
  mov [temp_color], ah

  set_page es, [_page_number]  ; es ... �a��Ϣ �A�a���a �A�a
  lds si, [image]              ; bx ... ������ ���i�� ���b��

  mov bx, [ds:si]     ; dx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4
  mov [image_carage], bx

  ; clipping y
  mov ax, [y]
  call _clipping_y
  jcxz @@exit

  calc_addr di, [x], ax   ; di ... �a��Ϣ ���a�u

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  mov dx, H_RES
  sub dx, bx         ; dx ... 320 - x_size

  sub [image_carage], bx   ; ������ ���i�� ā�����t
  mov ah, [temp_color]

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... skip color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... screen carage (320 - x_size)

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

  add si, [image_carage]
  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_clip : proc


END
