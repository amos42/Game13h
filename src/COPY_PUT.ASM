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
; Put_image : COPY_PUT·i ´á­Q§iŸ¡¡ ¤aŽ… ˆõ
; void copy_put( int x, int y, image_data image )
;*******************************************
proc copy_put  x:word, y:word, image:dword
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
  sub dx, bx      ; ax ... 320 - x_size

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
global copy_put : proc


END
