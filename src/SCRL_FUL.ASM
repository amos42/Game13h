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
;  ���e ���A�i �ᝡ �a�a�� ��ǥ�a.
; void scroll_up_screen( word step )
;***********************************
proc scroll_up_screen  step : word
  uses ds, es, si, di

  set_page ax, [_page_number]
  mov es, ax
  mov ds, ax

  mul_320 si, [step]
  xor di, di

  mov cx, 320*200
  sub cx, si
  shr cx, 1
  cld
  rep movsw

  ret
endp
global scroll_up_screen : proc


;*************************************
;  ���e ���a�i �a���� �a�a�� ��ǥ�a.
; void scroll_down_screen( word step )
;*************************************
proc scroll_down_screen  step : word
  uses ds, es, si, di

  set_page ax, [_page_number]
  mov es, ax
  mov ds, ax

  mov di, 320*200

  mov ax, [step]
  xchg ah, al
  mov bx, ax
  shr ax, 2
  add bx, ax
  mov si, 320*200
  sub si, bx

  mov cx, si
  shr cx, 1
  std
  rep movsw

  ret
endp
global scroll_down_screen : proc


END
