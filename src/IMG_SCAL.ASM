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


UDATASEG


DATASEG


CODESEG

;*******************************************
;  ·¡£¡»¡Ÿi ˆa¡ ­A¡ ˆbˆb x, y¤ ÑÂ”Ðe”a.
; void image_scale( int x, int y, image_data original_image, word scale_x, word scale_y )
;*******************************************
proc image_scale  x:word, y:word, original_image:dword, scale_x:word, scale_y:word
  local size_x, size_y, length : word
  uses ds, es, si, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]

  lds si, [original_image]

  cld

  lodsw
  mov [size_x], ax
  mov bx, [scale_x]
  mul bx
  mov [length], ax
  lodsw
  mov cx, ax
  dec [scale_y]

  mov dx, H_RES
  sub dx, [length]

  ; state :
  ;  ds:si ... ·¡£¡»¡· ¯¡¸b º­¡
  ;  es:di ... ÑÁ¡e· ¯¡¸b¶áÃ¡
  ;  bx ... xÂ‚ ÑÂ” §¡·i
  ;  cx ... ¶¥œ· yÇa‹¡
  ;  dx ... crage (320 - length)

 @@y_loop:
  push cx

  mov cx, [size_x]
 @@put_x_pixel:
  lodsb       ; ¸ñ·i ·ª´á scale_x¤å ¿¢“e”a.
  push cx
  mov cx, bx
  rep stosb
  pop cx
  loop @@put_x_pixel

  mov cx, [scale_y]
  jcxz @@y_skip

  ; Ðeº‰·i y¤å ­aËaÐe”a(­a¡ ÑÂ”Ÿi ŠÑeÐe”a).
  push ds si

  mov si, di
  add di, dx  ; ”a·qº‰ ¯¡¸b¶áÃ¡
  mov ax, es
  mov ds, ax

 @@put_y_pixel:
  mov ax, cx  ; push cx

  mov cx, [length]
  sub si, cx  ; siŸi x¬a·¡»a eÇq ÒÊa
  shr cx, 1
  jnc @@skip
  movsb
 @@skip:
  rep movsw
  add di, dx

  mov cx, ax  ; pop cx
  loop @@put_y_pixel

  pop si ds
  jmp @@y_no_skip

 @@y_skip:
  add di, dx

 @@y_no_skip:
  pop cx
  cmp di, 64000d
  jae @@exit
  loop @@y_loop

 @@exit:
  ret
endp
global image_scale : proc


END
