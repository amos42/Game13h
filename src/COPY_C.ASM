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
; copy_put()�� y�i��Ϸ ���
; void copy_put_clip_y( int x, int y, image_data image )
;****************************
proc copy_put_clip_y  x, y : word, image : dword
  uses ds, es, si, di

  ; es ... �a��Ϣ �A�a���a �A�a
  set_page es, [_page_number]

  ; bx ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]    ; bx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a */
  jcxz @@exit
  add si, 4

  ; clipping y
  mov ax, [y]            ; �i��Ϸ �a�� ��A ax�i �A�a
  call _clipping_y 
  jcxz @@exit

  calc_addr di, [x], ax  ; di ... �a��Ϣ ���a�U

  mov dx, H_RES
  sub dx, bx       ; ax ... 320 - x_size

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
global copy_put_clip_y : proc


;****************************
;  copy_put()�� x�i��Ϸ ���
; void copy_put_clip_x( int x, int y, image_data image )
;****************************
proc copy_put_clip_x  x, y : word, image : dword
  local temp:word
  uses ds, es, si, di

  ; es ... �a��Ϣ �A�a���a �A�a */
  set_page es, [_page_number]

  ; ds:si ... ������ ���i�� ���b�� */
  lds si, [image]

  mov bx, [ds:si]    ; dx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  calc_addr di, [x], [y]
  mov [temp], bx  ; bx ... Orignal size X

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  mov dx, H_RES
  sub dx, bx      ; ax ... 320 - x_size

  ; ax ... ������ ���i�� ā�����t
  mov ax, [temp]  ; ax ... Orignal size X
  sub ax, bx      ; ax ... New X - Old X

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ax ... image carage
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... screen carage (320 - x_size)

  cld

 @@loop:
  push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add si, ax
  add di, dx
  pop cx
  loop @@loop

 @@exit:
  ret
endp
global copy_put_clip_x : proc


;***************************
; copy_put()�� �i��Ϸ ���
; void copy_put_clip( int x, int y, image_data image )
;***************************
proc copy_put_clip  x, y : word, image : dword
  local temp:word
  uses ds, es, si, di

  ; es ... �a��Ϣ �A�a���a �A�a
  set_page es, [_page_number]

  ; ds:si ... ������ ���i�� ���b��
  lds si, [image]

  mov bx, [ds:si]     ; dx ... �������� x �a��
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... �������� y �a���i �A�a
  jcxz @@exit
  add si, 4

  ; clipping y
  mov ax, [y]
  call _clipping_y
  jcxz @@exit

  calc_addr di, [x], ax
  mov [temp], bx     ; bx ... Orignal size X

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  mov dx, H_RES
  sub dx, bx     ; ax ... 320 - x_size

  ; ax ... ������ ���i�� ā�����t
  mov ax, [temp] ; ax ... Orignal size X
  sub ax, bx     ; ax ... New X - Old X

  ; state :
  ;   ds:si ... ���i�� ������ ���b����
  ;   es:di ... ���e�w�� ������ ���b����
  ;   ax ... image carage (x_size + org_x_size)
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... screen carage (320 - x_size)

  cld

 @@loop:
  push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add si, ax
  add di, dx
  pop cx
  loop @@loop

 @@exit:
  ret
endp
global copy_put_clip : proc


END
