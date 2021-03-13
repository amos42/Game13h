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
P286
MODEL Large, C
DOSSEG

  include "game13h.inc"


UDATASEG


DATASEG


CODESEG

;********************
;  ®Íw¬å·i ‹aŸ¥”a.
; void line_horiz( int x, int y, word length, byte color )
;********************
proc line_horiz  x, y, length : word, color : byte
  uses es, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]

  cld
  mov cx, [length]
  jcxz @@exit

  mov al, [color]
  mov ah, al
  shr cx, 1
  jnc @@work
  stosb
  jcxz @@exit
 @@work:
  rep stosw

 @@exit:
  ret
endp
global line_horiz : proc


;*********************
;  ®»¢¬å·i ‹aŸ¥”a.
; void line_vert( int x, int y, word length, byte color )
;*********************
proc line_vert  x, y, length : word, color : byte
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  mov cx, [length]
  jcxz @@exit

  mov al, [color]
 @@work:
  mov [es:bx], al
  add bx, H_RES
  loop @@work

 @@exit:
  ret
endp
global line_vert : proc


;********************
;  ”ˆb¬å·i ‹aŸ¥”a.
; void line_cross( int x, int y, word length, byte color )
;********************
proc line_cross  x, y, length : word, color : byte
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  mov cx, [length]
  jcxz @@exit

  mov al, [color]
  mov ah, al
 @@work:
  mov [es:bx], al
  add bx, H_RES + 1
  loop @@work

 @@exit:
  ret
endp
global line_cross : proc


END
