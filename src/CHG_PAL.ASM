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

;***********************************
;  ���ụ ͡���ᝡ �i�A�a�i �a���a.
; void change_palette( palette_256 *palette_info )
;***********************************
proc change_palette  palette_info:dword
  uses ds, es, si, di

  lds si, [palette_info]

  xor al, al
  mov dx, 03C8h
  out dx, al

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
global change_palette : proc


;*****************************
;  �i�a�a�� �����e�i �a���a.
; void change_palette_part( palette_256 *palette_info, byte start_color, word change )
;*****************************
proc change_palette_part  palette_info:dword, start_color:byte, change:word
  uses ds, es, si, di

  lds si, [palette_info]

  mov al, [start_color]
  mov dx, 03C8h
  out dx, al

  mov ax, [change]
  mov cx, ax
  shl cx, 1
  add cx, ax

  cmp cx, 128 * 3
  jle @@one_time

  sub cx, 128 * 3
  mov bx, cx      ; push cx

 @@two_time:
  wait_write_dac  ; breaken al, dx
  mov dx, 03C9h

  rep outsb
  mov cx, bx      ; pop cx

 @@one_time:
  wait_write_dac 
  mov dx, 03C9h

  rep outsb

 @@exit:
  ret
endp
global change_palette_part : proc


END
