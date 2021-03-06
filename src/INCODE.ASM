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

  extrn farmalloc         : proc


UDATASEG


DATASEG


CODESEG

;**********************************
;  �����E ͡���᷁ �a�� �A����i
;  RLE�w���a�� �s�e�a.
; word incode_picture( char **data, word page )
;**********************************
proc incode_picture  data:dword, page:word
  uses ds, es, si, di

  call farmalloc, 0FFF0h, 0
  les bx, [data]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax

  set_page ds, [page]
  xor si, si

  cld
  lodsb

 @@incode_loop:
  mov ah, al
  lodsb
  cmp ah, al
  je @@rle

 @@no_rle:
  mov bx, di
  inc di
  xchg ah, al
  stosb
  xor cl, cl

 @@no_rle_loop:
  lodsb
  cmp ah, al
  je @@no_rle_end
  xchg ah, al
  stosb
  inc cl
  cmp cl, 01111111b
  jb @@no_rle_loop
  lodsb
 @@no_rle_end:
  mov [es:bx], cl
  dec si
  jmp @@end_check

 @@rle:
  xor cl, cl

 @@rle_loop:
  lodsb
  cmp ah, al
  jne @@rle_end
  inc cl
  cmp cl, 01111110b
  jb @@rle_loop
  lodsb
 @@rle_end:
  mov dl, al  ; push al
  mov al, cl
  not al
  stosw
  mov al, dl  ; pop al

 @@end_check:
  cmp di, 64000d
  jae @@faile
  cmp si, 64000d
  jbe @@incode_loop

  ; ���� �a���A �a�a �t�i ����
 @@success:
  mov ax, di
  jmp @@exit

 @@faile:
  xor ax, ax

 @@exit:
  ret
endp
global incode_image : proc


END
