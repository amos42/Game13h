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
;  xor �b�a�i �a���a.(���w�a ���w)
; void box_xor( int start_x, int start_y, int end_x, int end_y )
;*************************************
proc box_xor  start_x:word, start_y:word, end_x:word, end_y:word
  uses es, di

  mov cx, [end_y]
  sub cx, [start_y]
  cmp cx, 2
  jge @@next
  call bar_xor, [start_x], [start_y], [end_x], [end_y]
  jmp @@exit

 @@next:
  ; es:di ... �a��Ϣ �A�a���a, ���a�U �A�a
  ; not braken cx
  set_page es, [_page_number]
  calc_addr di, [start_x], [start_y]

  mov bx, [end_x]
  sub bx, [start_x]
  inc bx           ; bx ... �a�b�w�� x �a��
  dec cx           ; cx ... �a�b�w�� y �a���i �a�a (2�i �� ��)

  mov dx, H_RES
  sub dx, bx    ; dx ... 320 - x_size

  ; state :
  ;   es:di ... ���e�w�� �a�b�w ���b����
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  push cx
  mov cx, bx
 @@top_loop:
  xor [byte es:di], 0FFh
  inc di
  loop @@top_loop
  pop cx
  add di, dx

  inc dx
 @@side_loop:
  xor [byte es:di], 0FFh
  add di, bx
  dec di
  xor [byte es:di], 0FFh
  add di, dx
  loop @@side_loop

  mov cx, bx
 @@bottom_loop:
  xor [byte es:di], 0FFh
  inc di
  loop @@bottom_loop

 @@exit:
  ret
endp
global box_xor : proc


END
