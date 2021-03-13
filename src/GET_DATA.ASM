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

;******************************************************
;  Í¡·¥Èáˆa ˆaŸ¡Ç¡‰¡ ·¶“e ‰µµA¬á ¶¡—a•A·¡ÈáŸi ©³“e”a.
; word get_word( char *ptr )
;******************************************************
proc get_word  ptr:dword
  uses es

  les bx, [ptr]

  mov ax, [es:bx]
  xchg ah, al

  ret
endp
global get_word : proc


;**********************************************************
;  Í¡·¥Èáˆa ˆaŸ¡Ç¡‰¡ ·¶“e ‰µµa¬á ”á§i¶¡—a•a·¡ÈáŸi ©³“e”a.
; dword get_dword( char *ptr )
;**********************************************************
proc get_dword  ptr : dword
  uses es

  les bx, [ptr]

  mov dx, [es:bx]
  xchg dh, dl
  mov ax, [es:bx + 2]
  xchg ah, al

  ret
endp
global get_word : proc


END
