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

;****************
;  ��i ���e�a.
; void get_pixel( int x, int y )
;****************
proc get_pixel  x:word, y:word
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]
  mov al, [es:bx]

  ret
endp
global get_pixel : proc


;****************
;  ��i ���e�a.
; void put_pixel( int x, int y, byte color )
;****************
proc put_pixel  x:word, y:word, color:byte
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  mov al, [color]
  mov [es:bx], al

  ret
endp
global put_pixel : proc


;*********************
;  xor�� ��i ���e�a.
; void put_pixel_xor( int x, int y )
;*********************
proc put_pixel_xor  x:word, y:word
  uses es

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  xor [byte es:bx], 0FFh

  ret
endp
global put_pixel_xor : proc


END
