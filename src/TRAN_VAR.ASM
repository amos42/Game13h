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

;***************************************
;  char�w �����i �s�a int�w�a�� �e�e�a.
; void char_to_int( char char_high, char char_low, int *integer )
;***************************************
proc char_to_int  char_high:byte, char_low:byte, integer:dword
  uses es

  mov ah, [char_high]
  mov al, [char_low]

  les bx, [integer]
  mov [es:bx], ax

  ret
endp
global char_to_int : proc


;*********************************
;  int�w�a�� char������ �����e�a.
; void int_to_char( int integer, char *char_high, char *char_low )
;*********************************
proc int_to_char  integer:word, char_high:dword, char_low:dword
  uses es

  mov ax, [integer]

  les bx, [char_high]
  mov [es:bx], ah

  les bx, [char_low]
  mov [es:bx], al

  ret
endp
global int_to_char : proc


END
