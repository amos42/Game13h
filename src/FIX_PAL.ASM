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

;*******************************
;  �e���� �i�A�a�i ���b��ǥ�a.
; void fix_palette(void)
;*******************************
proc fix_palette
  uses es, di

  mov ax, DGROUP
  mov es, ax
  mov di, offset _palette

  xor al, al
  mov dx, 03C7h
  out dx, al
  mov cx, 768d
  mov dx, 03C9h

  cld
  rep insb

  ret
endp
global fix_palette : proc


;***************************************
;  �e���� �i�a�a�i ���b��ǥ�a.(���i��)
; void fix_palette_array( palette_256 *array, byte start_color, word change )
;***************************************
proc fix_palette_array  array:dword, start_color:byte, change:word
  uses es, di

  les di, [array]

  mov ax, [change]
  mov dx, 3
  mul dx
  mov cx, ax
  mov al, [start_color]
  mov dx, 03C7h
  out dx, al
  mov dx, 03C9h

  cld
  rep insb

  ret
endp
global fix_palette_array : proc


END
