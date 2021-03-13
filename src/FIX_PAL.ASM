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

;*******************************
;  Ñe¸· ÌiAËaŸi ¸÷Àb¯¡Ç¥”a.
; void fix_palette(void)
;*******************************
proc fix_palette
  uses es, di

  mov ax, DGROUP
  mov es, ax
  mov di, offset _palette

  xor al, al
  mov dx, 03C7h
  out dx, al
  mov cx, 768d
  mov dx, 03C9h

  cld
  rep insb

  ret
endp
global fix_palette : proc


;***************************************
;  Ñe¸· ÌiaËaŸi ¸÷Àb¯¡Ç¥”a.(¤µi¡)
; void fix_palette_array( palette_256 *array, byte start_color, word change )
;***************************************
proc fix_palette_array  array:dword, start_color:byte, change:word
  uses es, di

  les di, [array]

  mov ax, [change]
  mov dx, 3
  mul dx
  mov cx, ax
  mov al, [start_color]
  mov dx, 03C7h
  out dx, al
  mov dx, 03C9h

  cld
  rep insb

  ret
endp
global fix_palette_array : proc


END
