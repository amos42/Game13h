;*****************************************
;
;     ���a 13h�w �A�� �b�� �a���a�១
;                       Ver 4.2
;
;                 �A�b�a:
;                        �� �w ��
;
;  �A�� �b���i ��Ё �e�e �a���a�១����
; ���a 13h (320x200, 256) ��w���a.
;
;*****************************************
IDEAL
include "game13h.inc"


UDATASEG


DATASEG


CODESEG

;***********************************************
;  �����e �����e�q ���a�i�i ���b�h�e�a.(�w���e)
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
  xor si, si     ; string ͡����

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
