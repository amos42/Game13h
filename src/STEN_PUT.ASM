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

;*************************************************
; ¯aÉE¯© ÄéœáŸi ­¥¬w¯¡Ç¡»¡ ´g‰¡ ·¡£¡»¡Ÿi ¿¢“e”a.
; void stencil_put( int x, int y, image_data image, byte stencil )
;*************************************************
proc stencil_put  x:word, y:word, image:dword, stencil:byte
  local skip_color:byte
  uses ds, es, si, di

  mov al, [_attr_null_color]
  mov [skip_color], al

  ; es:di ... ‹aœÏ¢ ­a‹a åËa ­aËa
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa
  jcxz @@exit
  add si, 4

  mov ax, H_RES
  sub ax, bx         ; ax ... 320 - x_size

  mov dh, [stencil]  ; dh ... ¯aÉe¯© Äéœá

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ax ... carage (320 - x_size)
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dh ... stencil color

 @@y_loop:
  push cx

  mov cx, bx
 @@x_loop:
  cmp dh, [es:di]
  je @@skip
  mov dl, [ds:si]
  cmp dl, [skip_color]
  je @@skip
  mov [es:di], dl
 @@skip:
  inc si
  inc di
  loop @@x_loop

  pop cx
  add di, ax
  loop @@y_loop

 @@exit:
  ret
endp
global stencil_put : proc


;*************************************************************
;  ¯aÉe¯© Äéœáµa Ð”wÐa“e Äéœá e·i ¤aŽ¡e¬á ·¡£¡»¡Ÿi ¿¢“e”a.
; void stencil_put_opp( int x, int y, image_data image, byte opp_stencil )
;*************************************************************
proc stencil_put_opp  x:word, y:word, image:dword, opp_stencil:byte
  local skip_color:byte
  uses ds, es, si, di

  mov al, [_attr_null_color]
  mov [skip_color], al

  ; es:di ... ‹aœÏ¢ ­a‹a åËa ­aËa
  set_page es, [_page_number]
  calc_addr di, [x], [y]

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [image]

  mov bx, [si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa
  jcxz @@exit
  add si, 4

  mov ax, H_RES
  sub ax, bx         ; ax ... 320 - x_size

  mov dh, [opp_stencil]  ; dh ... ¯aÉe¯© Äéœá

  ; state :
  ;   ds:si ... ¤µi· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ÑÁ¡e¬w· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   ax ... carage (320 - x_size)
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dh ... oppsition stencil color

 @@y_loop:
  push cx

  mov cx, bx
 @@x_loop:
  cmp dh, [es:di]
  jne @@skip
  mov dl, [ds:si]
  cmp dl, [skip_color]
  je @@skip
  mov [es:di], dl
 @@skip:
  inc si
  inc di
  loop @@x_loop

  pop cx
  add di, ax
  loop @@y_loop

 @@exit:
  ret
endp
global stencil_put_opp : proc


END
