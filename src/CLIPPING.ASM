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
;         >> y�� �i��Ϸ <<
;
; Input  : ax - �������� y�t
;          bx - �������� x�a��
;          cx - �������� y�a��
;          si - �������� ���b����
; Ouptut : ax - �i��Ϸ�E y�t
;          cx - �i��Ϸ�E y�a��
;          si - �i��Ϸ�E ���b����
; Braken : di, dx
;***********************************
proc _clipping_y
  uses ds

  mov dx, DGROUP
  mov ds, dx

  cmp ax, [_max_y]
  jg @@no_put

  mov di, [_min_y]
  cmp ax, di
  jge @@bottom_clip

  sub di, ax        ; �i�a �a�a�e �a��
  sub cx, di        ; y�a�� �i��Ϸ
  mov ax, di
  mul bx            ; ax *= size_x
  add si, ax        ; ���b���� �i��Ϸ
  mov ax, [_min_y]  ; y�t �i��Ϸ

 @@bottom_clip:
  mov dx, ax
  add dx, cx
  cmp dx, [_min_y]
  jl @@no_put

  mov di, [_max_y]
  sub dx, di
  jle @@exit
  sub cx, dx
  inc cx
  jmp @@exit

 @@no_put:
  xor cx, cx

 @@exit:
  ret
endp
global _clipping_y : proc


;***********************************
;         >> x�� �i��Ϸ <<
;
; Input  : ax - �������� x�t
;          bx - �������� x�a��
;          si - �������� ���b����
;          di - ���������� ���b����
; Ouptut : bx - �i��Ϸ�E x�a��
;          si - �i��Ϸ�E ���b����
;          di - �i��Ϸ�E �������� ����
; Braken : ax, dx
;***********************************
proc _clipping_x
  uses ds

  mov dx, DGROUP
  mov ds, dx

  cmp ax, [_max_x]
  jg @@no_put

  mov dx, [_min_x]
  cmp ax, dx
  jge @@bottom_clip

  sub dx, ax        ; new_x - old_x
  add si, dx        ; ������ ���i �w�a
  sub bx, dx        ; x�a�� �i��Ϸ
  add di, dx        ; ������ �� ���� �i��Ϸ
  mov ax, [_min_x]  ; x�t �i��Ϸ

 @@bottom_clip:
  add ax, bx
  cmp ax, [_min_x]
  jl @@no_put

  mov dx, [_max_x]
  sub ax, dx
  jle @@exit

  sub bx, ax
  inc bx
  jmp @@exit

 @@no_put:
  xor bx, bx

 @@exit:
  ret
endp
global _clipping_x : proc


END
