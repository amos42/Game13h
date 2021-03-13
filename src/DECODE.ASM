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

;*************************************
;  »¡¸÷–E Í¡·¥Èá· ‹aŸ±·i —¡Å¡—·Ðaµa
;  »¡¸÷–E ÍA·¡»¡µA Îa¯¡Ðe”a.
; void decode_picture( char *data, word page )
;*************************************
proc decode_picture  data:dword, page:word
  uses ds, es, si, di

  set_page es, [page]
  xor di, di

  lds si, [data]

  xor ch, ch
  cld

 @@lc_loop:
  lodsb
  mov cl, al
  test cl, 10000000b
  jz @@no_rle

 @@rle:
  not cl
  add cx, 2
  lodsb
  rep stosb
  jmp @@next

 @@no_rle:
  inc cx
  rep movsb

 @@next:
  cmp di, 64000d
  jb @@lc_loop

  ret
endp
global decode_picture : proc


END
