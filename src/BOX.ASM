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

;*****************
;  ¤b¯aŸi ‹aŸ¥”a.
; void box( int start_x, int start_y, int end_x, int end_y, byte color )
;*****************
proc box  start_x:word, start_y:word, end_x:word, end_y:word, color:byte
  uses es, di

  mov cx, [end_y]
  sub cx, [start_y]
  cmp cx, 2
  jge @@next
  call bar, [start_x], [start_y], [end_x], [end_y], [word color]
  jmp @@exit

 @@next:
  ; es:di ... ‹aœÏ¢ ­A‹a åËa, µ¡Ïa­U ­AËa
  ; not braken cx
  set_page es, [_page_number]
  calc_addr di, [start_x], [start_y]

  mov bx, [end_x]
  sub bx, [start_x]
  inc bx           ; bx ... ¬aˆbÑw· x Ça‹¡
  dec cx           ; cx ... ¬aˆbÑw· y Ça‹¡Ÿi ­aËa (2Ÿi ¨… ®)

  mov al, [color]
  mov ah, al    ; ah, al ... color

  mov dx, H_RES
  sub dx, bx    ; dx ... 320 - x_size

  ; state :
  ;   es:di ... ÑÁ¡e¬w· ¬aˆbÑw ¯¡¸b¦¦…
  ;   al,ah ... color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

  push cx
  mov cx, bx
  shr cx, 1
  jnc @@top_skip
  stosb
  jcxz @@no_put
 @@top_skip:
  rep stosw
 @@no_put:
  add di, dx
  pop cx
  jcxz @@bottom

  sub bx, 2
 @@loop:
  stosb
  add di, bx
  stosb
  add di, dx
  loop @@loop
  add bx, 2

 @@bottom:
  mov cx, bx
  shr cx, 1
  jnc @@bottom_skip
  stosb
  jcxz @@exit
 @@bottom_skip:
  rep stosw

 @@exit:
  ret
endp
global box : proc


END
