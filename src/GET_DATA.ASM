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

;******************************************************
;  ͡����a �a��ǡ�� ���e ���A�� ���a�A����i ���e�a.
; word get_word( char *ptr )
;******************************************************
proc get_word  ptr:dword
  uses es

  les bx, [ptr]

  mov ax, [es:bx]
  xchg ah, al

  ret
endp
global get_word : proc


;**********************************************************
;  ͡����a �a��ǡ�� ���e ���a�� ��i���a�a����i ���e�a.
; dword get_dword( char *ptr )
;**********************************************************
proc get_dword  ptr : dword
  uses es

  les bx, [ptr]

  mov dx, [es:bx]
  xchg dh, dl
  mov ax, [es:bx + 2]
  xchg ah, al

  ret
endp
global get_word : proc


END
