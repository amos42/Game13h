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

;*************************************
;  xor ¤b¯aŸi ‹aŸ¥”a.(Äá¬á—wµa ·¡¶w)
; void box_xor( int start_x, int start_y, int end_x, int end_y )
;*************************************
proc box_xor  start_x:word, start_y:word, end_x:word, end_y:word
  uses es, di

  mov cx, [end_y]
  sub cx, [start_y]
  cmp cx, 2
  jge @@next
  call bar_xor, [start_x], [start_y], [end_x], [end_y]
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

  mov dx, H_RES
  sub dx, bx    ; dx ... 320 - x_size

  ; state :
  ;   es:di ... ÑÁ¡e¬w· ¬aˆbÑw ¯¡¸b¦¦…
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  push cx
  mov cx, bx
 @@top_loop:
  xor [byte es:di], 0FFh
  inc di
  loop @@top_loop
  pop cx
  add di, dx

  inc dx
 @@side_loop:
  xor [byte es:di], 0FFh
  add di, bx
  dec di
  xor [byte es:di], 0FFh
  add di, dx
  loop @@side_loop

  mov cx, bx
 @@bottom_loop:
  xor [byte es:di], 0FFh
  inc di
  loop @@bottom_loop

 @@exit:
  ret
endp
global box_xor : proc


END
