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

 ; byte menu_font[94][6/2]
 small_font db  22h,  20h,  20h,  55h,  00h,  00h,  5Fh,  5Fh, 0A0h
            db  2Fh, 0C3h, 0F4h,  91h,  68h,  90h,  36h, 0ABh,  50h
            db  24h,  00h,  00h,  12h,  22h,  10h,  84h,  44h,  80h
            db  96h, 0F6h,  90h,  02h,  72h,  00h,  00h,  00h,  48h
            db  00h,  70h,  00h,  00h,  00h,  40h,  13h,  6Ch,  80h
            db  69h,  99h,  60h,  26h,  22h,  20h,  69h,  24h, 0F0h
            db  69h,  29h,  60h, 0AAh, 0F2h,  20h, 0F8h, 0E1h, 0E0h
            db  68h, 0E9h,  60h, 0F1h,  24h,  40h,  69h,  69h,  60h
            db  69h,  71h,  60h,  04h,  04h,  00h,  04h,  04h,  80h
            db  12h,  42h,  10h,  07h,  07h,  00h,  84h,  24h,  80h
            db  69h,  20h,  20h,  69h, 0BDh, 0A0h,  69h, 0F9h,  90h
            db 0E9h, 0E9h, 0E0h,  69h,  89h,  60h, 0E9h,  99h, 0E0h
            db 0F8h, 0C8h, 0F0h, 0F8h, 0C8h,  80h,  78h, 0B9h,  60h
            db  99h, 0F9h,  90h,  22h,  22h,  20h,  11h,  19h,  60h
            db  9Ah, 0CAh,  90h,  88h,  88h, 0F0h,  9Fh, 0DDh, 0D0h
            db 0E9h,  99h,  90h,  69h,  99h,  60h, 0E9h, 0E8h,  80h
            db  69h,  9Bh,  71h, 0E9h, 0E9h,  90h,  78h,  61h, 0E0h
            db 0F4h,  44h,  40h,  99h,  99h,  60h,  99h,  9Ah,  40h
            db  9Bh, 0BBh,  50h,  99h,  69h,  90h,  99h,  71h,  60h
            db 0F1h,  24h, 0F0h,  74h,  44h,  70h,  8Ch,  63h,  10h
            db 0E2h,  22h, 0E0h,  25h,  00h,  00h,  00h,  00h,  0Fh
            db  21h,  00h,  00h,  06h,  99h,  70h,  8Eh,  99h, 0E0h
            db  06h,  88h,  60h,  17h,  99h,  70h,  06h,  9Ah,  70h
            db  24h, 0E4h,  40h,  06h,  97h,  16h,  8Eh,  99h,  90h
            db  20h,  22h,  20h,  10h,  11h,  16h,  89h, 0E9h,  90h
            db  62h,  22h,  20h,  06h, 0BBh, 0B0h,  0Eh,  99h,  90h
            db  06h,  99h,  60h,  0Eh,  9Eh,  88h,  06h,  97h,  11h
            db  06h,  88h,  80h,  06h,  91h,  60h,  4Eh,  44h,  20h
            db  0Ah, 0AAh, 0E0h,  0Ah, 0AAh,  40h,  09h, 0BBh, 0D0h
            db  09h,  69h,  90h,  09h,  97h,  13h,  0Fh,  24h, 0F0h
            db  12h,  11h,  21h,  22h,  22h,  22h,  84h,  88h,  48h
            db  5Ah,  00h,  00h


CODESEG

;************************
;  µw¢… 4x6¢…¸aŸi ¿¢“e”a.
; braken : cx, dx
;************************
macro put_fnt_small
  push si di

  mov cl, al
  xor ch, ch
  mov si, cx
  shl si, 1
  add si, cx
  add si, offset small_font
  mov cx, 3

 @@y_loop:
  lodsb
  mov dx, cx        ;; cxŸi ¥¡¹¥Ðe”a.

  mov cx, 4
 @@x_loop_1:
  shl al, 1
  jnc @@skip_1
  mov [es:di], ah
 @@skip_1:
  inc di
  loop @@x_loop_1
  add di, H_RES - 4

  mov cx, 4
 @@x_loop_2:
  shl al, 1
  jnc @@skip_2
  mov [es:di], ah
 @@skip_2:
  inc di
  loop @@x_loop_2

  add di, H_RES - 4
  mov cx, dx        ;; cxŸi ¥¢ŠÐe”a.
  loop @@y_loop

  pop di si
endm


;***********************************
;  ¡a“a ¸å¶w 4x6Í¥Ëa¡ ¢…¸aµi  e—q.
;***********************************
proc make_str_small  x:word, y:word, str_data:dword, color:byte
  local old_di:word
  uses ds, es, si, di

  set_page es, [_page_number]
  calc_addr di, [x], [y]
  mov [old_di], di

  mov ah, [color]
  lds si, [str_data]
  cld

 @@loop:
  mov bx, cx    ; push cx
  lodsb
  test al, al
  jz @@exit

  cmp al, 0Ah
  jne @@no_carage
  mov di, [old_di]
  add di, H_RES * 7
  mov [old_di], di
 @@no_carage:

  cmp al, '!'
  jl @@no_put
  sub al, '!'
  put_fnt_small  ; macro function
 @@no_put:

  add di, 5
  mov cx, bx   ; pop cx
  loop @@loop

 @@exit:
  ret
endp
global make_str_small : proc


END
