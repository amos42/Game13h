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
;  ¹Á¶¡ ¤e¸åÐ¬á ¿¢“e”a.(COPY_PUT)
; void copy_put_flip_hiriz( int x, int y, image_data image )
;*******************************************
proc copy_put_flip_horiz  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... ‹aœÏ¢ ­a‹a åËa ­AËa
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  jcxz @@exit
  add si, 4

  mov dx, H_RES
  add dx, bx      ; ax ... 320 + x_size

  dec di
  add di, bx   ; move point left end

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
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
;  ¬wÐa¡ ¤e¸åÐ¬á ¿¢“e”a.(COPY_PUT)
; void copy_put_flip_vert( int x, int y, image_data image )
;*******************************************
proc copy_put_flip_vert  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... ‹aœÏ¢ ­a‹a åËa ­AËa
  set_page es, [_page_number]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  jcxz @@exit
  add si, 4

  mov ax, [y]
  add ax, cx
  dec ax
  calc_addr di, [x], ax

  mov dx, H_RES
  add dx, bx      ; dx ... 320 + x_size

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
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
;  ¬wÐa¹Á¶¡ ¤e¸åÐ¬á ¿¢“e”a.(COPY_PUT)
; void copy_put_flip_both( int x, int y, image_data image )
;*******************************************
proc copy_put_flip_both  x:word, y:word, image:dword
  uses ds, es, si, di

  ; es:di ... ‹aœÏ¢ ­a‹a åËa ­AËa
  set_page es, [_page_number]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
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
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
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
