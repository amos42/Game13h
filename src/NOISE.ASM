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

;*************************
;  TV �����a�i ���e�e�a.
; void tv_noise(void)
;*************************
proc tv_noise
  uses es

  set_page es, [_page_number]

  xor bx, bx
  mov cx, 64000d
  in ax, 40h

 @@noise:
  add ax, 4321h
  rol ax, 1
  jnc @@put_dot

  mov [byte es:bx], 0
  jmp @@skip
 @@put_dot:
  mov [byte es:bx], 0FFh

 @@skip:
  inc bx
  loop @@noise

  ret
endp
global tv_noise : proc


;*************************************
;  tv �����a�i ���e�e�a.(�i��Ϸ �a�a)
; void tv_noise_clip(void)
;*************************************
proc tv_noise_clip
  uses es, si, di

  set_page es, [_page_number]
  calc_addr di, [_min_x], [_min_y]

  mov bx, [_max_x]
  sub bx, [_min_x]
  inc bx           ; bx ... �啡���� x�a��
  mov cx, [_max_y]
  sub cx, [_min_y]
  inc cx           ; cx ... �啡���� y�a��

  mov dx, H_RES
  sub dx, bx       ; dx ... carage (320 - x_size)

  in ax, 40h

 @@y_loop:
  mov si, cx  ; push cx
  mov cx, bx

 @@x_loop:
  add ax, 4321h
  rol ax, 1
  jnc @@put_dot

  mov [byte es:di], 0
  jmp @@next
 @@put_dot:
  mov [byte es:di], 0FFh

 @@next:
  inc di
  loop @@x_loop

  add di, dx
  mov cx, si  ; pop cx
  loop @@y_loop

  ret
endp
global tv_noise_clip : proc


END
