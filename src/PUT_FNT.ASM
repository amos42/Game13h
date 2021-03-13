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

;**********************
;  µw¢… ¢…¸aŸi ¿¢“e”a.
; void put_font( int x, int y, byte *chr, byte color )
;**********************
proc put_font_eng x:word, y:word, chr:dword, color:byte
  uses ds, es, si

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  lds si, [chr]
  mov ah, [color]
  mov cx, 16

  cld

 @@y_loop:
  lodsb
  mov dx, cx  ; cxŸi ¥¡¹¥Ðe”a.

  mov cx, 8
 @@x_loop:
  shl al, 1
  jnc @@skip
  mov [es:bx], ah
 @@skip:
  inc bx
  loop @@x_loop

  add bx, H_RES - 8
  mov cx, dx  ; cxŸi ¥¢ŠÐe”a.
  loop @@y_loop

  ret
endp
global put_font_eng: proc


;**********************
;  Ðe‹i ¢…¸aŸi ¿¢“e”a.
; void put_han_fnt( int x, int y, word *chr, byte color )
;**********************
proc put_font_han  x:word, y:word, chr:dword, color : byte
  uses ds, es, si, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]

  lds si, [chr]
  mov bl, [color]
  mov cx, 16

  cld

 @@y_loop:
  lodsw
  xchg ah, al
  mov dx, cx  ; cxŸi ¥¡¹¥Ðe”a.

  mov cx, 16
 @@x_loop:
  shl ax, 1
  jnc @@skip
  mov [es:di], bl
 @@skip:
  inc di
  loop @@x_loop

  add di, H_RES - 16
  mov cx, dx  ; cxŸi ¥¢ŠÐe”a.
  loop @@y_loop

  ret
endp
global put_font_han : proc


END
