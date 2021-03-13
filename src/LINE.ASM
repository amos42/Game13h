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
P286
MODEL Large, C
DOSSEG

  include "game13h.inc"


UDATASEG


DATASEG


CODESEG

;************************************
;  ¬å·i ‹aŸ¥”a. (§aŸ¡¯eÑq ´i‰¡Ÿ¡»q)
; void line( int start_x, int start_y, int end_x, int end_y, byte color )
;************************************
proc line  start_x, start_y, end_x, end_y : word, color : byte
  local half:word
  uses es, si, di

  ; ¢¹¡ˆå end¹ÁÎaˆa start¹ÁÎa¥¡”a Ça‰a Ðe”a.
  mov si, [end_x]
  sub si, [start_x]
  _if si less 0, a
    neg si
  _endif a
  inc si        ; delta_x = end_x - start_x + 1;

  mov di, [end_y]
  sub di, [start_y]
  _if di less 0, b
    neg di
  _endif b
  inc di       ; delta_y = end_y - start_y + 1;

  set_page es, [_page_number]
  calc_addr bx, [start_x], [start_y]

  mov dl, [color]
  xor ax, ax

  ; state :
  ;  si ... Delta X (x2 - x1 + 1)
  ;  di ... Delta Y (y2 - y1 + 1)
  ;  ax ... error term
  ;  bx ... start address
  ;  cx ... number loop
  ;  dl ... color

  _if si greate di, xx
    mov cx, si
    mov [half], si
    shr [half], 1
    push ax
    mov ax, [start_y]
    cmp ax, [end_y]
    pop ax
    jle @@easy_loop
    mov [byte cs:@@add_cmd+1], 0EBh    ; 81EBh => sub bx, ...

   @@easy_loop:
    mov [es:bx], dl
    inc bx
    add ax, di
    cmp ax, [half]
    jle @@e_next
    sub ax, si
   @@add_cmd:
    add bx, H_RES
   @@e_next:
    loop @@easy_loop

    mov [byte cs:@@add_cmd+1], 0C3h    ; 81C3h => add bx, ...
    jmp @@exit
  _endif xx

    mov cx, di
    mov [half], di
    shr [half], 1
    push ax
    mov ax, [start_x]
    cmp ax, [end_x]
    pop ax
    jle @@steel_loop
    mov [byte cs:@@inc_cmd], 4Bh       ; 4Bh => dec bx

   @@steel_loop:
    mov [es:bx], dl
    add bx, H_RES
    add ax, si
    cmp ax, [half]
    jle @@s_next
    sub ax, di
   @@inc_cmd:
    inc bx
   @@s_next:
    loop @@steel_loop

    mov [byte cs:@@inc_cmd], 43h       ; 43h => inc bx

 @@exit:
  ret
endp
global line : proc


END
