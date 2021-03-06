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

;*****************
;  �b�a�i �a���a.
; void box( int start_x, int start_y, int end_x, int end_y, byte color )
;*****************
proc box  start_x:word, start_y:word, end_x:word, end_y:word, color:byte
  uses es, di

  mov cx, [end_y]
  sub cx, [start_y]
  cmp cx, 2
  jge @@next
  call bar, [start_x], [start_y], [end_x], [end_y], [word color]
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

  mov al, [color]
  mov ah, al    ; ah, al ... color

  mov dx, H_RES
  sub dx, bx    ; dx ... 320 - x_size

  ; state :
  ;   es:di ... ���e�w�� �a�b�w ���b����
  ;   al,ah ... color
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

  push cx
  mov cx, bx
  shr cx, 1
  jnc @@top_skip
  stosb
  jcxz @@no_put
 @@top_skip:
  rep stosw
 @@no_put:
  add di, dx
  pop cx
  jcxz @@bottom

  sub bx, 2
 @@loop:
  stosb
  add di, bx
  stosb
  add di, dx
  loop @@loop
  add bx, 2

 @@bottom:
  mov cx, bx
  shr cx, 1
  jnc @@bottom_skip
  stosb
  jcxz @@exit
 @@bottom_skip:
  rep stosw

 @@exit:
  ret
endp
global box : proc


END
