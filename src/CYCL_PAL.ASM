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

;****************************************
;  ·©¸÷Ðe ¤ñ¶á · ÌiAËaŸi ®…ÑÅ¯¡Ç¥”a.
; void cycle_palette( byte start_color, byte end_color )
;****************************************
proc cycle_palette  start_color:byte, end_color:byte
  uses es, si, di

  mov ax, ds
  mov es, ax

  xor ah, ah
  mov al, [start_color]
  mov si, ax
  mov al, [end_color]
  mov di, ax

  cmp si, di
  jne @@process
  jmp @@exit

 @@process:
  ja @@anti_direct

    mov dx, si    ; start_color
    mov cx, di
    sub cx, si
    mov dh, cl    ; change

    ; cx *= 3
    mov ax, cx
    shl cx, 1
    add cx, ax

    ; si = &_palette[si * 3]
    mov ax, si
    shl si, 1
    add si, ax
    add si, offset _palette

    mov ah, [si]
    mov al, [si+1]
    mov bh, [si+2]

    mov di, si
    add si, 3

    cld
    shr cx, 1
    jnc @@e_skip
    movsb
   @@e_skip:
    rep movsw

    mov [di], ah
    mov [di+1], al
    mov [di+2], bh
    jmp @@change_pal

 @@anti_direct:
    mov dx, di   ; start_color
    mov cx, si
    sub cx, di
    mov dh, cl   ; change

    ; cx *= 3
    mov ax, cx
    shl cx, 1
    add cx, ax

    ; si = &_palette[si * 3]
    mov ax, si
    shl si, 1
    add si, ax
    add si, offset _palette

    mov ah, [si]
    mov al, [si+1]
    mov bh, [si+2]

    add si, 2
    mov di, si
    sub si, 3

    std
    shr cx, 1
    jnc @@s_skip
    movsb
   @@s_skip:
    rep movsw

    mov [di-2], ah
    mov [di-1], al
    mov [di], bh
    cld

 @@change_pal:
  _if_zero [_change_palette_flag], @@exit

  mov al, dl     ; start
  mov cl, dh     ; change
  xor ch, ch
  inc cx
  mov dx, 03C8h
  out dx, al

  xor ah, ah
  mov si, ax
  shl si, 1
  add si, ax
  add si, offset _palette

  mov ax, cx
  shl cx, 1
  add cx, ax

  cmp cx, 128 * 3
  jle @@one_time

 @@two_time:
  sub cx, 128 * 3
  mov bx, cx      ; push cx

  wait_write_dac  ; breaken al, dx
  mov dx, 03C9h

  rep outsb
  mov cx, bx      ; pop cx

 @@one_time:
  wait_write_dac 
  mov dx, 03C9h

  rep outsb

 @@exit:
  ret
endp
global cycle_palette : proc


END
