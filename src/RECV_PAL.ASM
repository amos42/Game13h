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

;****************************
;  �e���� �i�A�a�i �����e�a.
; void recover_palette(void)
;****************************
proc recover_palette
  uses si

  mov si, offset _palette

  xor al, al
  mov dx, 03C8h
  out dx, al
  cld

  wait_write_dac
  mov dx, 03C9h
  mov cx, 128 * 3
  rep outsb

  wait_write_dac
  mov dx, 03C9h
  mov cx, 128 * 3
  rep outsb

  ret
endp
global recover_palette : proc


END
