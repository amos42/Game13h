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
P286
MODEL Large, C
DOSSEG

  include "game13h.inc"


UDATASEG


DATASEG


CODESEG

;********************
;  ���w��i �a���a.
; void line_horiz( int x, int y, word length, byte color )
;********************
proc line_horiz  x, y, length : word, color : byte
  uses es, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]

  cld
  mov cx, [length]
  jcxz @@exit

  mov al, [color]
  mov ah, al
  shr cx, 1
  jnc @@work
  stosb
  jcxz @@exit
 @@work:
  rep stosw

 @@exit:
  ret
endp
global line_horiz : proc


;*********************
;  ������i �a���a.
; void line_vert( int x, int y, word length, byte color )
;*********************
proc line_vert  x, y, length : word, color : byte
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  mov cx, [length]
  jcxz @@exit

  mov al, [color]
 @@work:
  mov [es:bx], al
  add bx, H_RES
  loop @@work

 @@exit:
  ret
endp
global line_vert : proc


;********************
;  ���b��i �a���a.
; void line_cross( int x, int y, word length, byte color )
;********************
proc line_cross  x, y, length : word, color : byte
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  mov cx, [length]
  jcxz @@exit

  mov al, [color]
  mov ah, al
 @@work:
  mov [es:bx], al
  add bx, H_RES + 1
  loop @@work

 @@exit:
  ret
endp
global line_cross : proc


END
