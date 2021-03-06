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

;************************************
;  �w�� ���a�i ���e�a. (��ˡ ��ᝡ)
; void put_font_multi( int x, int y, byte *chr, byte start_color )
;************************************
proc put_font_multi_eng x:word, y:word, chr:dword, start_color:byte
  uses ds, es, si

  set_page es, [_page_number]
  calc_addr bx, [x], [y]

  lds si, [chr]
  mov ah, [start_color]
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
  inc ah
  mov cx, dx  ; cx�i �����e�a.
  loop @@y_loop

  ret
endp
global put_font_multi_eng: proc


;*************************************
;  �e�i ���a�i ���e�a. (��ˡ ��ᝡ)
; void put_font_multi_han( int x, int y, word *chr, byte start_color )
;*************************************
proc put_font_multi_han  x:word, y:word, chr:dword, start_color:byte
  uses ds, es, si, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]

  lds si, [chr]
  mov bl, [start_color]
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
  inc bl
  mov cx, dx  ; cx�i �����e�a.
  loop @@y_loop

  ret
endp
global put_font_multi_han : proc


END
