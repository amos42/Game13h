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

;********************************
;  ÑÁ¡e·i »¡¸÷Ðe ¬‚Œi¡ »¡¶…”a.
; voic clear_screen( byte color )
;********************************
proc clear_screen  color:byte
  uses es, di

  set_page es, [_page_number]
  xor di, di

  mov al, [color]
  mov ah, al
  mov cx, 320*200/2

  cld
  rep stosw

  ret
endp
global clear_screen : proc


END
