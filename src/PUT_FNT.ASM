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

;**********************
;  �w�� ���a�i ���e�a.
; void put_font( int x, int y, byte *chr, byte color )
;**********************
proc put_font_eng x:word, y:word, chr:dword, color:byte
  uses ds, es, si

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  lds si, [chr]
  mov ah, [color]
  mov cx, 16

  cld

 @@y_loop:
  lodsb
  mov dx, cx  ; cx�i �����e�a.

  mov cx, 8
 @@x_loop:
  shl al, 1
  jnc @@skip
  mov [es:bx], ah
 @@skip:
  inc bx
  loop @@x_loop

  add bx, H_RES - 8
  mov cx, dx  ; cx�i �����e�a.
  loop @@y_loop

  ret
endp
global put_font_eng: proc


;**********************
;  �e�i ���a�i ���e�a.
; void put_han_fnt( int x, int y, word *chr, byte color )
;**********************
proc put_font_han  x:word, y:word, chr:dword, color : byte
  uses ds, es, si, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]

  lds si, [chr]
  mov bl, [color]
  mov cx, 16

  cld

 @@y_loop:
  lodsw
  xchg ah, al
  mov dx, cx  ; cx�i �����e�a.

  mov cx, 16
 @@x_loop:
  shl ax, 1
  jnc @@skip
  mov [es:di], bl
 @@skip:
  inc di
  loop @@x_loop

  add di, H_RES - 16
  mov cx, dx  ; cx�i �����e�a.
  loop @@y_loop

  ret
endp
global put_font_han : proc


END
