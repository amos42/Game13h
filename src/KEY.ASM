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

;*********************
;  ǡ����i �A���e�a.
; void clear_key(void)
;*********************
proc clear_key
  uses es

  mov ax, 40h
  mov es, ax

  mov ax, [es:1Ah]
  mov [es:1Ch], ax
  ret
endp
global clear_key : proc


;********************************************
;  ǡ����A ǡ�t�i ���e�a.(ǡ����e �i����)
; void put_key( int key )
;********************************************
proc put_key  key:word
  uses es

  mov ax, 40h
  mov es, ax

  mov ax, [key]
  mov [es:1Eh], ax

  mov [word es:1Ah], 1Eh
  mov [word es:1Ch], 20h

  ret
endp
global put_key : proc


;********************
;  ǡ�i ���b�h�e�a.
; int get_key(void)
;********************
proc get_key
 @@loop:
  xor ah, ah
  int 16h
  mov bx, ax
  mov ah, 1
  int 16h
  jnz @@loop

  test bl, bl
  jz @@no_change
  xor bh, bh
 @@no_change:
  mov ax, bx

  ret
endp
global get_key : proc


;******************************
;  �����e�a�� ǡ�i ���b�h�e�a.
; int action_key(void)
;******************************
proc action_key
  mov ah, 1
  int 16h
  jz @@skip

  call get_key
  jmp @@exit

 @@skip:
  xor ax, ax

 @@exit:
  ret
endp
global action_key : proc


;**************************
;  ǡ���a ���b�i ���a���a.
; void delay_key(void)
;**************************
proc delay_key
  uses es

  mov ax, 40h
  mov es, ax

  mov ax, [es:1Ah]
  mov [es:1Ch], ax

  xor ah, ah
  int 16h

  ret
endp
global delay_key : proc


END
