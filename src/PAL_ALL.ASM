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

;**************************************
;  ÌiAËaŸi ¡¡– Ðe ÌiAËa¡ ­AËaÐe”a.
; void all_palette( byte color )
;**************************************
proc all_palette  color:byte
  mov bl, [color]
  xor bh, bh

  ; bx *= 3
  mov ax, bx
  shl bx, 1
  add bx, ax

  ; ah = Red, bh = Green, bl = Blue
  mov ah, [bx + _palette.red]
  mov al, [bx + _palette.green]
  mov bl, [bx + _palette.blue]
  mov bh, al

  xor al, al
  mov dx, 03C8h
  out dx, al

  wait_write_dac
  mov dx, 03C9h
  mov cx, 128d

 @@loop_1:
  mov al, ah
  out dx, al
  mov al, bh
  out dx, al
  mov al, bl
  out dx, al
  loop @@loop_1

  wait_write_dac
  mov dx, 03C9h
  mov cx, 128d

 @@loop_2:
  mov al, ah
  out dx, al
  mov al, bh
  out dx, al
  mov al, bl
  out dx, al
  loop @@loop_2

  ret
endp
global all_palette : proc


END
