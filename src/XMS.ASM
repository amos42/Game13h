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

  struc xms_struct
    length      dd ?
    s_handle    dw ?
    s_offset    dd ?
    d_handle    dw ?
    d_offset    dd ?
  ends


UDATASEG

  xms_call    procedure <>
  move_struct xms_struct <>


DATASEG


CODESEG

;***************************
;  XMS ���I�i ������ �e�a.
; int xms_install()
;***************************
proc xms_install
  uses es

  mov ax, 4300h
  int 2Fh

  cmp al, 80h
  jne @@exit

  mov ax, 4310h
  int 2Fh

  mov [xms_call.reg_cs], es
  mov [xms_call.reg_ip], bx
  xor ax, ax
  ret

 @@exit:
  mov ax, 1
  ret
endp
global xms_install : proc


;*************************************
;  �a�w�a�w�e XMS�� �a���i �i�a���a.
; int xms_size( int option )
;*************************************
proc xms_size  option : word
  mov ah, 08h
  call [dword xms_call]

  test [option], LARGEST_SIZE
  je @@exit

  mov ax, dx

 @@exit:
  ret
endp
global xms_size : proc


;*********************************
;  XMS�A�����i �i�w�e�a.(kb�e��)
; int xms_alloc( word size )
;*********************************
proc xms_alloc  block_size : word
  mov ah, 09h
  mov dx, [block_size]
  call [dword xms_call]

  test ax, ax
  jz @@exit

  mov ax, dx

 @@exit:
  ret
endp
global xms_alloc : proc


;************************
;  �A�����i �A�i�w�e�a.
; int xms_realloc( int handle, word new_size )
;************************
proc xms_realloc  handle, new_size : word
  mov ah, 0Fh
  mov bx, [new_size]
  mov dx, [handle]
  call [dword xms_call]

  test ax, ax
  jnz @@success
  mov al, bl
  jmp @@exit

 @@success:
  xor ax, ax

 @@exit:
  ret
endp
global xms_realloc : proc


;*******************************
;  �i�w�E XMS�A�����i Ё�A�e�a.
; int xms_free( int handle )
;*******************************
proc xms_free  handle : word
  mov ah, 0Ah
  mov dx, [handle]
  call [dword xms_call]

  test ax, ax
  jnz @@success
  mov al, bl
  jmp @@exit

 @@success:
  xor ax, ax

 @@exit:
  ret
endp
global xms_free : proc


;*******************************
;  �b�� Ѕ�i�� XMS�i ��ѡ�e�a.
; int xms_lock( int handle, char *linear_addr )
;*******************************
proc xms_lock  handle : word, xms_linear_addr : dword
  mov ah, 0Ch
  mov dx, [handle]
  call [dword xms_call]

  test ax, ax
  jnz @@success
  mov al, bl
  jmp @@exit

 @@success:
  mov ax, bx
  push es
  les bx, [xms_linear_addr]
  mov [es:bx+2], dx
  mov [es:bx], ax
  pop es
  xor ax, ax

 @@exit:
  ret
endp
global xms_lock : proc


;************************
;  XMS Lock�i Ё�A�e�a.
; int xms_unlock( int handle )
;************************
proc xms_unlock  handle : word
  mov ah, 0Dh
  mov dx, [handle]
  call [dword xms_call]

  test ax, ax
  jnz @@success
  mov al, bl
  jmp @@exit

 @@success:
  xor ax, ax

 @@exit:
  ret
endp
global xms_unlock : proc


;***************************
;  �A�� �a�A���A�� XMS��
;  �A���� �i��i ���a�e�a.
; int xms_push( int handle, char *data, dword data_length )
;***************************
proc xms_push  handle : word, data : dword, data_length : dword
  uses si

  mov ax, [word high data_length]
  mov [word high move_struct.length], ax
  mov ax, [word low data_length]
  mov [word low move_struct.length], ax
  mov [move_struct.s_handle], 0
  mov ax, [word high data]
  mov [word high move_struct.s_offset], ax
  mov ax, [word low data]
  mov [word low move_struct.s_offset], ax
  mov ax, [handle]
  mov [move_struct.d_handle], ax
  mov [word high move_struct.d_offset], 0
  mov [word low move_struct.d_offset], 0

  mov si, offset move_struct
  mov ah, 0Bh
  call [dword xms_call]

  test ax, ax
  jnz @@success
  mov al, bl
  jmp @@exit

 @@success:
  xor ax, ax

 @@exit:
  ret
endp
global xms_push : proc


;***************************
;  XMS�A�� �A�� �a�A���a��
;  �A���� �i��i ���a�e�a.
; int xms_pop( int handle, char *data, dword data_length )
;***************************
proc xms_pop  handle : word, data : dword, data_length : dword
  uses si

  mov ax, [word high data_length]
  mov [word high move_struct.length], ax
  mov ax, [word low data_length]
  mov [word low move_struct.length], ax
  mov ax, [handle]
  mov [move_struct.s_handle], ax
  mov [word high move_struct.s_offset], 0
  mov [word low move_struct.s_offset], 0
  mov [move_struct.d_handle], 0
  mov ax, [word high data]
  mov [word high move_struct.d_offset], ax
  mov ax, [word low data]
  mov [word low move_struct.d_offset], ax

  mov si, offset move_struct
  mov ah, 0Bh
  call [dword xms_call]

  test ax, ax
  jnz @@success
  mov al, bl
  jmp @@exit

 @@success:
  xor ax, ax

 @@exit:
  ret
endp
global xms_pop : proc


END
