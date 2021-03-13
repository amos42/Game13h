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

;***************************
; copy_put()· yÇiŸ¡Ï· ¤á¸å
; void copy_put_clip_y( int x, int y, image_data image )
;****************************
proc copy_put_clip_y  x, y : word, image : dword
  uses ds, es, si, di

  ; es ... ‹aœÏ¢ ­A‹a åËa ­AËa
  set_page es, [_page_number]

  ; bx ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa */
  jcxz @@exit
  add si, 4

  ; clipping y
  mov ax, [y]            ; ÇiŸ¡Ï· Ða‹¡ ¸åµA axŸi ­AËa
  call _clipping_y 
  jcxz @@exit

  calc_addr di, [x], ax  ; di ... ‹aœÏ¢ µ¡Ïa­U

  mov dx, H_RES
  sub dx, bx       ; ax ... 320 - x_size

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
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
;  copy_put()· xÇiŸ¡Ï· ¤á¸å
; void copy_put_clip_x( int x, int y, image_data image )
;****************************
proc copy_put_clip_x  x, y : word, image : dword
  local temp:word
  uses ds, es, si, di

  ; es ... ‹aœÏ¢ ­A‹a åËa ­AËa */
  set_page es, [_page_number]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ */
  lds si, [image]

  mov bx, [ds:si]    ; dx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
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

  ; ax ... ·¡£¡»¡ ¤µi· ÄŸ¡»¡ˆt
  mov ax, [temp]  ; ax ... Orignal size X
  sub ax, bx      ; ax ... New X - Old X

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
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
; copy_put()· ÇiŸ¡Ï· ¤á¸å
; void copy_put_clip( int x, int y, image_data image )
;***************************
proc copy_put_clip  x, y : word, image : dword
  local temp:word
  uses ds, es, si, di

  ; es ... ‹aœÏ¢ ­A‹a åËa ­AËa
  set_page es, [_page_number]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [ds:si]     ; dx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
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

  ; ax ... ·¡£¡»¡ ¤µi· ÄŸ¡»¡ˆt
  mov ax, [temp] ; ax ... Orignal size X
  sub ax, bx     ; ax ... New X - Old X

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
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
