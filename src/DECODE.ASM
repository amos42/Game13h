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

;*************************************
;  �����E ͡���᷁ �a���i ��š���a�a
;  �����E �A�����A �a���e�a.
; void decode_picture( char *data, word page )
;*************************************
proc decode_picture  data:dword, page:word
  uses ds, es, si, di

  set_page es, [page]
  xor di, di

  lds si, [data]

  xor ch, ch
  cld

 @@lc_loop:
  lodsb
  mov cl, al
  test cl, 10000000b
  jz @@no_rle

 @@rle:
  not cl
  add cx, 2
  lodsb
  rep stosb
  jmp @@next

 @@no_rle:
  inc cx
  rep movsb

 @@next:
  cmp di, 64000d
  jb @@lc_loop

  ret
endp
global decode_picture : proc


END
