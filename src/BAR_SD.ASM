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

;******************************
;  ‹aŸ±¸a »¥ ¬aˆbÑw·i ‹aŸ¥”a.
; void bar_shade( int start_x, int start_y, int end_x, int end_y, char shade )
;******************************
proc bar_shade  start_x:word, start_y:word, end_x:word, end_y:word, shade:byte
  uses ds, es, si, di

  ; es:di = ds:si ... ‹aœÏ¢ ­A‹a åËa, µ¡Ïa­U
  set_page ax, [_page_number]
  mov ds, ax
  mov es, ax
  calc_addr si, [start_x], [start_y]
  mov di, si

  mov bx, [end_x]
  sub bx, [start_x]
  inc bx          ; bx ... ¬aˆbÑw· x Ça‹¡
  mov cx, [end_y]
  sub cx, [start_y]
  inc cx          ; cx ... ¬aˆbÑw· y Ça‹¡Ÿi ­aËa

  mov dx, H_RES
  sub dx, bx      ; dx ... 320 - x_size
  mov ah, [shade] ; ah ... shade

  ; state :
  ;   es:di ... ÑÁ¡e¬w· ¬aˆbÑw ¯¡¸b¦¦…
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  add al, ah
  stosb
  loop @@x_loop

  add di, dx
  mov si, di
  pop cx
  loop @@y_loop

  ret
endp
global bar_shade : proc


END
