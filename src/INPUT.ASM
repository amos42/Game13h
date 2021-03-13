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

;***********************************************
;  »¡¸÷Ðe ‹©·¡ eÇq ¢…¸aµi·i ·³b¤h“e”a.(µw¢… e)
; int input_string( int x, int y, char *str, byte color, word length )
;***********************************************
proc input_string  x:word, y:word, str_ptr:dword, color:byte, length:word
  uses es, si, di

  xor al, al
  les di, [str_ptr]
  mov bx, di
  mov cx, [length]
  cld
  rep stosb
  mov di, bx
  xor si, si     ; string Í¡·¥Èá

 @@input_char:
  call get_key

  cmp ax, 0008h
  jne @@next
  cmp si, 0
  jbe @@next
  dec si
  mov bx, si
  mov [byte es:di + bx], 0
  sub [x], 8
  mov ax, [x]
  add ax, 7
  mov bx, [y]
  add bx, 15
  call bar, [x], [y], ax, bx, LIGHTGRAY
  jmp @@no_input

 @@next:
  cmp si, [length]
  jae @@no_input
  cmp ax, 10h
  jb @@no_input
  mov bx, si
  mov [es:di + bx], al
  inc si
  call put_char_eng, [x], [y], ax, [word color]
  add [x], 8

 @@no_input:
  cmp ax, _ENTER
  je @@exit
  cmp ax, _ESC
  je @@exit
  jmp @@input_char

 @@exit:
  ret
endp
global input_string : proc


END
