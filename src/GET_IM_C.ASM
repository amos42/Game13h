;*****************************************
;
;     ¡¡—a 13h¶w ‰a·± ¸b¬÷ œa·¡§aœáŸ¡
;                       ver 4.2
;
;                 ¹a¸b¸a:
;                        º ‰w £¥
;
;  ‰a·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
; ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.
;
;*****************************************
IDEAL
include "game13h.inc"

  extrn farmalloc         : proc


UDATASEG


DATASEG


CODESEG

;******************************
;  get_image()· ÇiŸ¡Ï· ¤á¸å.
; void get_image_clip( int start_x, int start_y, int end_x, int end_y, image_data *image )
;******************************
proc get_image_clip  start_x, start_y, end_x, end_y : word, image : dword
  uses ds, es, si, di

  mov ax, [start_x]
  mov bx, [end_x]
  mov cx, [end_y]
  mov dx, [start_y]
  mov si, bx
  mov di, cx

  _if ax less [_min_x], a
    mov ax, [_min_x]
  _endif a
  _if bx greate [_max_x], b
    mov bx, [_max_x]
  _endif b
  _if dx less [_min_y], c
    mov dx, [_min_y]
  _endif c
  _if cx greate [_max_y], d
    mov cx, [_max_y]
  _endif d

  ; size_x = end_x - start_x + 1
  ; size_y = end_y - start_y + 1;
  sub bx, ax
  inc bx
  sub cx, dx
  inc cx

  _if ax greate [_max_x], aa
    xor bx, bx
  _endif aa
  _if si less [_min_x], bb
    xor bx, bx
  _endif bb
  _if dx greate [_max_y], cc
    xor cx, cx
  _endif cc
  _if di less [_min_y], dd
    xor cx, cx
  _endif dd

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
  test bx, bx
  jz @@exit
  mov [es:di+2], cx
  jcxz @@exit
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

 @@exit:
  ret
endp
global get_image_clip : proc


;*********************************
;  get_image_fix()· ÇiŸ¡Ï· ¤á¸å.
; void get_image_fix_clip( int start_x, int start_y, int end_x, int end_y, image_data image )
;*********************************
proc get_image_fix_clip  start_x, start_y, end_x, end_y : word, image : dword
  uses ds, es, si, di

  mov ax, [start_x]
  mov bx, [end_x]
  mov cx, [end_y]
  mov dx, [start_y]
  mov si, bx
  mov di, cx

  _if ax less [_min_x], a
    mov ax, [_min_x]
  _endif a
  _if bx greate [_max_x], b
    mov bx, [_max_x]
  _endif b
  _if dx less [_min_y], c
    mov dx, [_min_y]
  _endif c
  _if cx greate [_max_y], d
    mov cx, [_max_y]
  _endif d

  ; size_x = end_x - start_x + 1
  ; size_y = end_y - start_y + 1;
  sub bx, ax
  inc bx
  sub cx, dx
  inc cx

  _if ax greate [_max_x], aa
    xor bx, bx
  _endif aa
  _if si less [_min_x], bb
    xor bx, bx
  _endif bb
  _if dx greate [_max_y], cc
    xor cx, cx
  _endif cc
  _if di less [_min_y], dd
    xor cx, cx
  _endif dd

  push bx
  set_page ds, [_page_number]         ; breaken bx
  calc_addr si, [start_x], [start_y]  ; breaken ax
  pop bx

  les di, [image]

  mov [es:di], bx
  test bx, bx
  jz @@exit
  mov [es:di+2], cx
  jcxz @@exit
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
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add si, ax
  mov cx, dx  ; pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global get_image_fix_clip : proc


END
