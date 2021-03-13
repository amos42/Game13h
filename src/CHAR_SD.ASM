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


;*****************************
;  ÄŸ¢Èá· ‹aŸ±¸a e ¿¢“e”a.
; void char_put_shade( int x, int y, image_data image, char shade )
;*****************************
proc char_put_shade  x:word, y:word, image:dword, shade:byte
  uses ds, es, si, di

  ; es:di ... ‹aœÏ¢ ­A‹a åËa, µ¡Ïa­U ­AËa
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  mov ah, [_attr_null_color]    ; ah ... skip_color
  mov al, [shade]               ; al ... shade_color

  ; si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ */
  lds si, [image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa
  jcxz @@exit
  add si, 4

  mov dx, H_RES
  sub dx, bx         ; dx ... 320 - x_size

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip_color
  ;   al ... shade
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  cmp ah, [ds:si]
  je @@skip
  add [es:di], al
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
global char_put_shade : proc


;**********************************
;   char_put_shade· ÇiŸ¡Ï· ¤á¸å
; void char_put_shade_clip( int x, int y, image_data image, char shade )
;**********************************
proc char_put_shade_clip  x:word, y:word, image:dword, shade:byte
  local image_carage:word, screen_carage:word
  local temp:word
  uses ds, es, si, di

  mov ah, [_attr_null_color]    ; ah ... skip_color
  mov al, [shade]               ; al ... shade
  mov [temp], ax

  set_page es, [_page_number]  ; es ... ‹aœÏ¢ ­a‹a åËa ­aËa
  lds si, [image]              ; ds:bx ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]     ; dx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa
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

  sub [image_carage], bx   ; ·¡£¡»¡ ¤µi· ÄŸ¡»¡ˆt

  ; dh ... skip color
  ; dl ... shade
  mov dx, [temp]

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dh ... skip color
  ;   dl ... shade

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  cmp al, dh
  je @@skip
  add [es:di], dl
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
global char_put_shade_clip : proc


END
