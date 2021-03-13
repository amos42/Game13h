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

  extrn farmalloc         : proc


UDATASEG


DATASEG


CODESEG

;*********************
; ·¡£¡»¡Ÿi ¥¢¬aÐe”a.
; void image_copy( image_data source_image, image_data *target_image )
;*********************
proc image_copy  source_image:dword, target_image:dword
  uses ds, es, si, di

  ; ds:si ... ·¡£¡»¡ ¤µi· ¯¡¸b¸ñ
  lds si, [source_image]

  mov bx, [ds:si]    ; bx ... ·¡£¡»¡· x Ça‹¡
  test bx, bx
  jz @@exit
  mov cx, [ds:si+2]  ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­AËa
  jcxz @@exit

  push ds
  mov ax, DGROUP
  mov ds, ax

  mov ax, bx
  mul cx
  add ax, 4   ; ax = size_x * size_y + 4
  push ax
  call farmalloc, ax, dx
  pop cx
  les bx, [target_image]
  mov [es:bx+2], dx
  mov [es:bx], ax
  mov es, dx
  mov di, ax

  pop ds
  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@exit
 @@skip:
  rep movsw

 @@exit:
  ret
endp
global image_copy : proc


END
