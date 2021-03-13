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

;***************************************
;  charÑw –ˆŸi ÐsÁa intÑw·a¡  e—e”a.
; void char_to_int( char char_high, char char_low, int *integer )
;***************************************
proc char_to_int  char_high:byte, char_low:byte, integer:dword
  uses es

  mov ah, [char_high]
  mov al, [char_low]

  les bx, [integer]
  mov [es:bx], ax

  ret
endp
global char_to_int : proc


;*********************************
;  intÑw·a¡ char–ˆ¡ ¦…Ÿ¡Ðe”a.
; void int_to_char( int integer, char *char_high, char *char_low )
;*********************************
proc int_to_char  integer:word, char_high:dword, char_low:dword
  uses es

  mov ax, [integer]

  les bx, [char_high]
  mov [es:bx], ah

  les bx, [char_low]
  mov [es:bx], al

  ret
endp
global int_to_char : proc


END
