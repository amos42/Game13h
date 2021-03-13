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

;***********************************
;         >> y· ÇiŸ¡Ï· <<
;
; Input  : ax - ·¡£¡»¡· yˆt
;          bx - ·¡£¡»¡· xÇa‹¡
;          cx - ·¡£¡»¡· yÇa‹¡
;          si - ·¡£¡»¡· ¯¡¸bº­¡
; Ouptut : ax - ÇiŸ¡Ï·–E yˆt
;          cx - ÇiŸ¡Ï·–E yÇa‹¡
;          si - ÇiŸ¡Ï·–E ¯¡¸bº­¡
; Braken : di, dx
;***********************************
proc _clipping_y
  uses ds

  mov dx, DGROUP
  mov ds, dx

  cmp ax, [_max_y]
  jg @@no_put

  mov di, [_min_y]
  cmp ax, di
  jge @@bottom_clip

  sub di, ax        ; ¼ia aˆa“e Ça‹¡
  sub cx, di        ; yÇa‹¡ ÇiŸ¡Ï·
  mov ax, di
  mul bx            ; ax *= size_x
  add si, ax        ; ¯¡¸bº­¡ ÇiŸ¡Ï·
  mov ax, [_min_y]  ; yˆt ÇiŸ¡Ï·

 @@bottom_clip:
  mov dx, ax
  add dx, cx
  cmp dx, [_min_y]
  jl @@no_put

  mov di, [_max_y]
  sub dx, di
  jle @@exit
  sub cx, dx
  inc cx
  jmp @@exit

 @@no_put:
  xor cx, cx

 @@exit:
  ret
endp
global _clipping_y : proc


;***********************************
;         >> x· ÇiŸ¡Ï· <<
;
; Input  : ax - ·¡£¡»¡· xˆt
;          bx - ·¡£¡»¡· xÇa‹¡
;          si - ·¡£¡»¡· ¯¡¸bº­¡
;          di - §¡—¡µ¡œ‘· ¯¡¸bº­¡
; Ouptut : bx - ÇiŸ¡Ï·–E xÇa‹¡
;          si - ÇiŸ¡Ï·–E ¯¡¸bº­¡
;          di - ÇiŸ¡Ï·–E §¡—¡µ¡œ‘ º­¡
; Braken : ax, dx
;***********************************
proc _clipping_x
  uses ds

  mov dx, DGROUP
  mov ds, dx

  cmp ax, [_max_x]
  jg @@no_put

  mov dx, [_min_x]
  cmp ax, dx
  jge @@bottom_clip

  sub dx, ax        ; new_x - old_x
  add si, dx        ; ·¡£¡»¡ ¤µi »wˆa
  sub bx, dx        ; xÇa‹¡ ÇiŸ¡Ï·
  add di, dx        ; §¡—¡µ¡ œ‘ º­¡ ÇiŸ¡Ï·
  mov ax, [_min_x]  ; xˆt ÇiŸ¡Ï·

 @@bottom_clip:
  add ax, bx
  cmp ax, [_min_x]
  jl @@no_put

  mov dx, [_max_x]
  sub ax, dx
  jle @@exit

  sub bx, ax
  inc bx
  jmp @@exit

 @@no_put:
  xor bx, bx

 @@exit:
  ret
endp
global _clipping_x : proc


END
