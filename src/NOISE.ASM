;*****************************************
;
;     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
;                       Ver 4.2
;
;                 ¹A¸b¸a:
;                        º ‰w £¥
;
;  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
; ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.
;
;*****************************************
IDEAL
include "game13h.inc"


UDATASEG


DATASEG


CODESEG

;*************************
;  TV ‘¡·¡»aŸi ŠÑeÐe”a.
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
;  tv ‘¡·¡»aŸi ŠÑeÐe”a.(ÇiŸ¡Ï· ÁaÇa)
; void tv_noise_clip(void)
;*************************************
proc tv_noise_clip
  uses es, si, di

  set_page es, [_page_number]
  calc_addr di, [_min_x], [_min_y]

  mov bx, [_max_x]
  sub bx, [_min_x]
  inc bx           ; bx ... ¶å•¡¶· xÇa‹¡
  mov cx, [_max_y]
  sub cx, [_min_y]
  inc cx           ; cx ... ¶å•¡¶· yÇa‹¡

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
