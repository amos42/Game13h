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

;********************************
;  ���e�i �����e ���i�� �����a.
; voic clear_screen( byte color )
;********************************
proc clear_screen  color:byte
  uses es, di

  set_page es, [_page_number]
  xor di, di

  mov al, [color]
  mov ah, al
  mov cx, 320*200/2

  cld
  rep stosw

  ret
endp
global clear_screen : proc


END
