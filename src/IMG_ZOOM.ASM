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

  extrn farmalloc   : proc


UDATASEG


DATASEG


CODESEG

;*******************************************
;  ·¡£¡»¡Ÿi ·±· ¤ ÑÂ”,Â‚­¡ Ðe”a.
; void image_zoom( image_data source_image, image_data *target_image, int zoom_x, int zoom_y )
;*******************************************
proc image_zoom  source_image:dword, target_image:dword, zoom_x:word, zoom_y:word
  local size_x:word, size_y:word
  local reg_si:word, source_addr:word
  uses ds, es, si, di

  mov ax, [zoom_x]
  mul [zoom_y]
  add ax, 4   ; ax = size_x * size_y + 4
  call farmalloc, ax, dx
  les di, [target_image]
  mov [es:di+2], dx
  mov [es:di], ax
  mov es, dx
  mov di, ax

  mov bx, [zoom_x]
  mov cx, [zoom_y]
  mov [es:di], bx
  test bx, bx
  jz @@exit
  mov [es:di+2], cx
  jcxz @@exit
  add di, 4

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [source_image]

  mov ax, [ds:si]    ; ·¡£¡»¡· x Ça‹¡
  test ax, ax
  jz @@exit
  mov [size_x], ax
  mov ax, [ds:si+2]  ; ·¡£¡»¡· y Ça‹¡
  test ax, ax
  jz @@exit
  mov [size_y], ax
  add si, 4
  mov [reg_si], si

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÂ”–I ·¡£¡»¡ ¯¡¸b¦¦…
  ;   bx ... zoom_x
  ;   cx ... zoom_y

  xor dx, dx
  cld

;  for( i = 0; i < zoom_y; i ++ ){
;    sa = si+4 + (i * size_y / zoom_y) * size_x;
;    for( j = 0; j < zoom_x; j ++ )
;      *da++ = *(sa + j * size_x / zoom_x);

 @@y_loop:
  push cx dx

  mov ax, [size_y]
  mul dx
  div cx
  mul [size_x]
  add ax, [reg_si]
  mov [source_addr], ax

  mov cx, [size_x]
  xor dx, dx
 @@x_loop:
  push dx

  mov ax, cx
  mul dx
  div bx
  mov si, [source_addr]
  add si, ax
  movsb

  pop dx
  inc dx
  cmp dx, bx
  jb @@x_loop

  pop dx cx
  inc dx
  cmp dx, cx
  jb @@y_loop

 @@exit:
  ret
endp
global image_zoom : proc


END
