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
;  ¹Á¶¡ ¤e¸åÐ¬á ¿¢“e”a.(CHAR_PUT)
; void char_put_flip_hiriz( int x, int y, image_data image )
;*******************************************
proc char_put_flip_horiz  x:word, y:word, image:dword
  uses ds, es, si, di

  ; ah ... skip_color
  mov ah, [_attr_null_color]
  push ax

  ; es:di ... ‹aœÏ¢ ­A‹a åËa, µ¡Ïa­U ­AËa
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  lds si, [image] ; si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  jcxz @@exit
  add si, 4

  mov dx, H_RES
  add dx, bx      ; ax ... 320 + x_size

  dec di
  add di, bx      ; move point left end

  pop ax          ; ah ... skip color

  ; state :
  ;   si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip color
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
  mov [es:di], al
 @@skip:
  dec di
  loop @@x_loop

  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_flip_horiz : proc


;*******************************************
;  ¬wÐa¡ ¤e¸åÐ¬á ¿¢“e”a.(CHAR_PUT)
; void char_put_flip_vert( int x, int y, image_data image )
;*******************************************
proc char_put_flip_vert  x:word, y:word, image:dword
  uses ds, es, si, di

  ; ah ... skip_color
  mov ah, [_attr_null_color]
  push ax

  ; es:di ... ‹aœÏ¢ ­A‹a åËa, µ¡Ïa­U ­AËa
  set_page es, [_page_number]

  lds si, [image] ; si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  test cx, cx
  jz @@exit
  add si, 4

  mov ax, [y]
  add ax, cx
  dec ax
  calc_addr di, [x], ax

  mov dx, H_RES
  add dx, bx      ; dx ... 320 + x_size

  pop ax          ; ah ... skip color

  ; state :
  ;   si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip color
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
  mov [es:di], al
 @@skip:
  inc di
  loop @@x_loop

  sub di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_flip_vert : proc


;*******************************************
;  ¬wÐa¹Á¶¡ ¤e¸åÐ¬á ¿¢“e”a.(CHAR_PUT)
; void char_put_flip_both( int x, int y, image_data image )
;*******************************************
proc char_put_flip_both  x:word, y:word, image:dword
  uses ds, es, si, di

  ; ah ... skip_color
  mov ah, [_attr_null_color]
  push ax

  ; es:di ... ‹aœÏ¢ ­A‹a åËa, µ¡Ïa­U ­AËa
  set_page es, [_page_number]

  lds si, [image] ; si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  test cx, cx
  jz @@exit
  add si, 4

  mov ax, [y]
  add ax, cx
  dec ax
  calc_addr di, [x], ax

  mov dx, H_RES
  sub dx, bx      ; dx ... 320 - x_size

  dec di
  add di, bx   ; move point left end

  pop ax          ; ah ... skip color

  ; state :
  ;   si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip color
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
  mov [es:di], al
 @@skip:
  dec di
  loop @@x_loop

  sub di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_flip_both : proc


END
