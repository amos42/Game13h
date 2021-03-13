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
;  char_put· yÇiŸ¡Ï· ¤á¸å
; void char_put_clip_y( int x, int y, image_data image )
;***************************
proc char_put_clip_y  x:word, y:word, image:dword
  local temp_color:byte, temp:word
  uses ds, es, si, di

  mov ah, [_attr_null_color]   ; ah ... skip_color
  mov [temp_color], ah

  set_page es, [_page_number]  ; es ... ‹aœÏ¢ ­A‹a åËa ­AËa
  lds si, [image]              ; bx ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]     ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  jcxz @@exit
  add si, 4

  ; clipping y
  mov ax, [y]
  call _clipping_y
  jcxz @@exit

  calc_addr di, [x], ax  ; si ... ·¡£¡»¡ µ¡Ïa­u

  mov dx, H_RES
  sub dx, bx     ; dx ... 320 - x_size

  mov ah, [temp_color]

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip_color
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
  stosb
  jmp @@next
 @@skip:
  inc di
 @@next:
  loop @@x_loop

  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_clip_y : proc


;***************************
;  char_put· xÇiŸ¡Ï· ¤á¸å
; void char_put_clip_x( int x, int y, image_data image )
;***************************
proc char_put_clip_x  x:word, y:word, image:dword
  local image_carage:word, temp_color:byte
  uses ds, es, si, di

  mov ah, [_attr_null_color]   ; ah ... skip_color
  mov [temp_color], ah

  set_page es, [_page_number]  ; es ... ‹aœÏ¢ ­A‹a åËa ­AËa
  lds si, [image]              ; bx ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]     ; bx ... ·¡£¡»¡· x Ça‹¡
  mov cx, [ds:si+2]   ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  add si, 4
  mov [image_carage], bx

  calc_addr di, [x], [y]  ; di ... ‹aœÏ¢ µ¡Ïa­u

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  mov dx, H_RES
  sub dx, bx         ; dx ... 320 - x_size

  sub [image_carage], bx   ; ·¡£¡»¡ ¤µi· ÄŸ¡»¡ˆt
  mov ah, [temp_color]

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... screen carage (320 - x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  cmp al, ah
  je @@skip
  stosb
  jmp @@next
 @@skip:
  inc di
 @@next:
  loop @@x_loop

  add si, [image_carage]
  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_clip_x : proc


;***************************
;  char_put· xÇiŸ¡Ï· ¤á¸å
; void char_put_clip( int x, int y, image_data image )
;***************************
proc char_put_clip  x:word, y:word, image:dword
  local image_carage:word, temp_color:byte
  uses ds, es, si, di

  mov ah, [_attr_null_color]   ; ah ... skip_color
  mov [temp_color], ah

  set_page es, [_page_number]  ; es ... ‹aœÏ¢ ­A‹a åËa ­AËa
  lds si, [image]              ; bx ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ

  mov bx, [ds:si]     ; dx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]   ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  jcxz @@exit
  add si, 4
  mov [image_carage], bx

  ; clipping y
  mov ax, [y]
  call _clipping_y
  jcxz @@exit

  calc_addr di, [x], ax   ; di ... ‹aœÏ¢ µ¡Ïa­u

  ; clipping x
  mov ax, [x]
  call _clipping_x
  test bx, bx
  jz @@exit

  mov dx, H_RES
  sub dx, bx         ; dx ... 320 - x_size

  sub [image_carage], bx   ; ·¡£¡»¡ ¤µi· ÄŸ¡»¡ˆt
  mov ah, [temp_color]

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ah ... skip color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... screen carage (320 - x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  cmp al, ah
  je @@skip
  stosb
  jmp @@next
 @@skip:
  inc di
 @@next:
  loop @@x_loop

  add si, [image_carage]
  add di, dx
  pop cx
  loop @@y_loop

 @@exit:
  ret
endp
global char_put_clip : proc


END
