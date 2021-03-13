;*****************************************
;
;     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
;                       Ver 4.2
;
;                 ¹A¸b¸a:
;                        º ‰w £¥
;
;  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
; ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.
;
;*****************************************
IDEAL
include "game13h.inc"

  extrn farmalloc         : proc


UDATASEG


DATASEG


CODESEG

;*******************************************
;  ÑÁ¡e· ·©¦¦…·i ·¡£¡»¡¡ ¤áÌáµA ¸á¸wÐe”a.
; void get_image( int start_x, int start_y, int end_x, int end_y, image_data *image )
;********************************************/
proc get_image  start_x, start_y, end_x, end_y : word, image : dword
  uses ds, es, si, di

  ; size_x = end_x - start_x + 1
  mov bx, [end_x]
  sub bx, [start_x]
  inc bx

  ; size_y = end_y - start_y + 1
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx

  push bx cx

  mov ax, bx
  mul cx
  add ax, 4   ; ax = size_x * size_y + 4
  call farmalloc, ax, dx
  les bx, [image]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax

  set_page ds, [_page_number]
  calc_addr si, [start_x], [start_y]

  pop cx bx

  mov [es:di], bx
  mov [es:di+2], cx
  add di, 4

  mov dx, H_RES
  sub dx, bx

  cld

 @@y_loop:
  mov ax, cx  ; push cx

  mov cx, bx
  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add si, dx
  mov cx, ax  ; pop cx
  loop @@y_loop

  ret
endp
global get_image : proc


;*************************************************
;  get_image()µÁ ˆ{·aa ¡A¡¡Ÿ¡Ÿi Ði”wÐa»¡ ´g“e”a.
; void get_image_fix( int start_x, int start_y, int end_x, int end_y, image_data image )
;*************************************************
proc get_image_fix  start_x, start_y, end_x, end_y : word, image : dword
  uses ds, es, si, di

  set_page ds, [_page_number]
  calc_addr si, [start_x], [start_y]

  les di, [image]

  ; size_x = end_x - start_x + 1
  mov bx, [end_x]
  sub bx, [start_x]
  inc bx

  ; size_y = end_y - start_y + 1
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx

  mov [es:di], bx
  mov [es:di+2], cx
  add di, 4

  mov ax, H_RES
  sub ax, bx

  cld

 @@y_loop:
  mov dx, cx  ; push cx
  mov cx, bx
  shr cx, 1
  jnc @@skip
  movsb
 @@skip:
  jcxz @@no_get
  rep movsw
 @@no_get:

  add si, ax
  mov cx, dx  ; pop cx
  loop @@y_loop

  ret
endp
global get_image_fix : proc


END
