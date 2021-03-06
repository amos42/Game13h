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

  extrn farmalloc : proc
  extrn farfree   : proc


UDATASEG


DATASEG

  _last_page_number dw 0


CODESEG

;*******************************
;  �A�����A �A�����i �i�w�e�a.
; int init_page( word add_page )
;*******************************
proc init_page  add_page:word
  uses si, di

  mov di, [add_page]
  cmp di, 3
  ja @@over_flow
  cmp di, 1
  jb @@over_flow

  mov [_last_page_number], di
  mov si, 1

 @@loop:
  call farmalloc, (H_RES * V_RES) + 8, 0
  inc dx
  mov bx, si
  shl bx, 1
  mov [_screen_page + bx], dx
  inc si
  cmp si, di
  jbe @@loop

  mov [_page_number], 0
  xor ax, ax
  jmp @@exit

 @@over_flow:
  mov ax, 1

 @@exit:
  ret
endp
global init_page : proc


;*************************************
;  �����E �A������ ͡����i �����e�a.
; char *page_pointer( word page )
;*************************************
proc page_pointer  page : word
  set_page dx, [page]
  xor ax, ax

  ret
endp


;*******************************************
;  �A�����i ��Ё �i�w�E �A�����i Ё�w�e�a.
; void close_page(void)
;*******************************************
proc close_page
  uses si, di

  mov di, [_last_page_number]
  cmp di, 1
  jb @@exit

  mov [_page_number], 0
  mov si, 1

 @@loop:
  set_page dx, si
  dec dx
  call farfree, 8, dx
  mov bx, si
  shl bx, 1
  mov [_screen_page + bx], GRAPH_SEG
  inc si
  cmp si, di
  jbe @@loop

 @@exit:
  ret
endp
global close_page : proc


;****************************************
;  �e �a�����a�� �a�e �a������ ���a�e�a.
; void copy_page( word source_page, word target_page )
;****************************************
proc copy_page  source_page:word, target_page:word
  uses ds, es, si, di

  set_page es, [target_page]
  set_page ds, [source_page]

  xor si, si
  xor di, di
  mov cx, (H_RES * V_RES) / 2

  cld
  rep movsw

  ret
endp
global copy_page : proc


;***********************************
;  �����e �a�����i �ɬ��� ��ǥ�a.
;  �e, �����e max_page���a �b�e ��.
; void activity_page( word page )
;***********************************
proc activity_page  page:word
  uses ds, es, si, di

  mov [_page_number], 0

  set_page ds, [page]
  mov ax, GRAPH_SEG
  mov es, ax

  xor si, si
  xor di, di
  mov cx, (H_RES * V_RES) / 2

  cld
  rep movsw

  ret
endp
global activity_page : proc


END
