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

;****************
;  ¸ñ·i ·ª“e”a.
; void get_pixel( int x, int y )
;****************
proc get_pixel  x:word, y:word
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]
  mov al, [es:bx]

  ret
endp
global get_pixel : proc


;****************
;  ¸ñ·i ¿¢“e”a.
; void put_pixel( int x, int y, byte color )
;****************
proc put_pixel  x:word, y:word, color:byte
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  mov al, [color]
  mov [es:bx], al

  ret
endp
global put_pixel : proc


;*********************
;  xor¡ ¸ñ·i ¿¢“e”a.
; void put_pixel_xor( int x, int y )
;*********************
proc put_pixel_xor  x:word, y:word
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  xor [byte es:bx], 0FFh

  ret
endp
global put_pixel_xor : proc


END
