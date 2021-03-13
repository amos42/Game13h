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

;****************************
;  Ñe¸· ÌiAËaŸi ¥¢ŠÐe”a.
; void recover_palette(void)
;****************************
proc recover_palette
  uses si

  mov si, offset _palette

  xor al, al
  mov dx, 03C8h
  out dx, al
  cld

  wait_write_dac
  mov dx, 03C9h
  mov cx, 128 * 3
  rep outsb

  wait_write_dac
  mov dx, 03C9h
  mov cx, 128 * 3
  rep outsb

  ret
endp
global recover_palette : proc


END
