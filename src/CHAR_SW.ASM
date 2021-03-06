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
;  ā���᷁ �a���a�e ���e�a.
; void char_put_shadow( int x, int y, image_data image )
;*****************************
proc char_put_shadow  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... �a��Ϣ �A�a���a, ���a�U �A�a
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  mov ah, [_attr_null_color]    ; ah ... skip_color
  mov al, [_attr_shadow_color]  ; al ... put_color

  ; si ... ������ ���i�� ���b�� */
  lds si, [image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �a�a
  jcxz @@exit
  add si, 4

  mov dx, H_RES
  sub dx, bx         ; dx ... 320 - x_size

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ah ... skip_color
  ;   al ... shadow_color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  cmp ah, [ds:si]
  je @@skip
  mov [es:di], al
 @@skip:
  inc si
  inc di
  loop @@x_loop

  pop cx
  add di, dx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_shadow : proc


;**********************************
;   char_put_shade�� �i��Ϸ ���
; void char_put_shadow_clip( int x, int y, image_data image )
;**********************************
proc char_put_shadow_clip  x:word, y:word, image:dword
  local image_carage:word, screen_carage:word
  local temp:word
  uses ds, es, si, di

  mov ah, [_attr_null_color]    ; ah ... skip_color
  mov al, [_attr_shadow_color]  ; al ... shadow color
  mov [temp], ax

  set_page es, [_page_number]  ; es ... �a��Ϣ �a�a���a �a�a
  lds si, [image]              ; ds:bx ... ������ ���i�� ���b��

  mov bx, [ds:si]     ; dx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... �������� y �a���i �a�a
  jcxz @@exit
  add si, 4
  mov [image_carage], bx

  ; clipping y
  mov ax, [y]
  call _clipping_y
  jcxz @@exit

  calc_addr di, [x], ax

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  ; screen carage ... 320 - x_size
  mov [screen_carage], H_RES
  sub [screen_carage], bx

  sub [image_carage], bx   ; ������ ���i�� ā�����t

  ; dh ... skip color
  ; dl ... shade color
  mov dx, [temp]

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dh ... skip color
  ;   dl ... shadow color

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  cmp al, dh
  je @@skip
  mov [es:di], dl
 @@skip:
  inc di
  loop @@x_loop

  add si, [image_carage]
  add di, [screen_carage]
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_shadow_clip : proc


END
