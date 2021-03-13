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

;***********************************
;  ÑÁ¡e ¸åÁAŸi ¶á¡ ¯aÇa© ¯¡Ç¥”a.
; void scroll_up_screen( word step )
;***********************************
proc scroll_up_screen  step : word
  uses ds, es, si, di

  set_page ax, [_page_number]
  mov es, ax
  mov ds, ax

  mul_320 si, [step]
  xor di, di

  mov cx, 320*200
  sub cx, si
  shr cx, 1
  cld
  rep movsw

  ret
endp
global scroll_up_screen : proc


;*************************************
;  ÑÁ¡e ¸åÁaŸi ´aœ¡ ¯aÇa© ¯¡Ç¥”a.
; void scroll_down_screen( word step )
;*************************************
proc scroll_down_screen  step : word
  uses ds, es, si, di

  set_page ax, [_page_number]
  mov es, ax
  mov ds, ax

  mov di, 320*200

  mov ax, [step]
  xchg ah, al
  mov bx, ax
  shr ax, 2
  add bx, ax
  mov si, 320*200
  sub si, bx

  mov cx, si
  shr cx, 1
  std
  rep movsw

  ret
endp
global scroll_down_screen : proc


END
