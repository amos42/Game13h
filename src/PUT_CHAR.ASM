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

  han_1      db ?
  han_2      db ?
  han_3      db ?
  eng        db ?
  han_font_1 dd ?
  han_font_2 dd ?
  han_font_3 dd ?


DATASEG

  table_1  db  0,  0,  1,  2,  3,  4,  0,  0,  5,  6,  7,  8,  9, 10
           db  0,  0, 11, 12, 13, 14, 15, 16,  0,  0, 17, 18, 19, 20
  table_2  db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  2,  2
           db  0,  0,  2,  1,  1,  2,  2,  2,  0,  0,  1,  1,  2,  0


CODESEG

;************************************
;  ¢…¸a ÉA·¡§i·i ·¡¶wÐ ¿¢·i Í¥ËaŸi
;  ‰©œa ‹a Í¡·¥ÈáŸi ­aËa.
;************************************
proc _analysis_font_addr
  uses si, di

  ; si = table_2[ han_2 ];
  xor bh, bh
  mov bl, [han_2]
  dec bl
  dec bl
  mov bl, [table_2 + bx]
  mov si, bx

  mov bl, [han_3]
  dec bl
  test bl, bl
  jz @@no_jong
  dec bl
  shl bx, 5                 ; mul bx, 16*2
  add bx, offset _hangul3
  mov [word han_font_3 + 2], ds
  mov [word han_font_3], bx
  xor bh, bh

  add si, 3
  mov di, 16*2*21
  jmp @@next_1
 @@no_jong:
  xor di, di

 @@next_1:
  mov bl, [han_1]
  dec bl
  jz @@next_2
  ; han_font_1 = _hangul1[ si ][ han_1 - 1 ];
  imul si, 16*2*19
  add si, offset _hangul1
  dec bl
  shl bx, 5                 ; mul bx, 16*2
  add si, bx
  mov [word han_font_1 + 2], ds
  mov [word han_font_1], si
  xor bh, bh

 @@next_2:
  mov bl, [han_2]
  dec bl
  dec bl
  jz @@exit
  ; han_font_2 = _hangul2[ di ][ table_1[ han_2 - 2 ] ];
  add di, offset _hangul2
  mov bl, [table_1 + bx]
  shl bx, 5                 ; mul bx, 16*2
  add di, bx
  mov [word han_font_2 + 2], ds
  mov [word han_font_2], di

 @@exit:
  ret
endp


;***************************
;  Ðe ¢…¸a· Ðe‹i·i ¿¢“e”a.
;***************************
proc put_char_han  x:word, y:word, code:word, color:byte
  uses es, si, di

  mov ax, [code]

  mov dl, al
  and dl, 00011111b
  mov [han_3], dl

  shr ax, 5
  mov dl, al
  and dl, 00011111b
  mov [han_2], dl

  shr ax, 5
  and al, 00011111b
  mov [han_1], al

  call _analysis_font_addr
  mov si, [x]
  mov di, [y]

  mov al, [han_1]
  dec al
  jz @@next_1
  les bx, [han_font_1]
  call put_font_han, si, di, bx, es, [word color]
 @@next_1:
  mov al, [han_2]
  dec al
  dec al
  jz @@next_2
  les bx, [han_font_2]
  call put_font_han, si, di, bx, es, [word color]
 @@next_2:
  mov al, [han_3]
  dec al
  jz @@exit
  les bx, [han_font_3]
  call put_font_han, si, di, bx, es, [word color]

 @@exit:
  ret
endp
global put_char_han : proc


;***************************
;  Ðe ¢…¸a· µw´áŸi ¿¢“e”a.
;***************************
proc put_char_eng  x:word, y:word, code:byte, color:byte
  uses es, si, di

  mov al, [code]
  cmp al, '!'
  jb @@exit
  sub al, '!'
  xor ah, ah
  shl ax, 4     ; ax *= 16

  mov bx, offset _english
  add bx, ax
  call put_font_eng, [x], [y], bx, ds, [word color]

 @@exit:
  ret
endp
global put_char_eng : proc


;***************************
;  Ðe ¢…¸a· Ðe‹i·i ¿¢“e”a.
;***************************
proc put_char_multi_han  x:word, y:word, code:word, start_color:byte
  uses es, si, di

  mov ax, [code]

  mov dl, al
  and dl, 00011111b
  mov [han_3], dl

  shr ax, 5
  mov dl, al
  and dl, 00011111b
  mov [han_2], dl

  shr ax, 5
  and al, 00011111b
  mov [han_1], al

  call _analysis_font_addr
  mov si, [x]
  mov di, [y]

  mov al, [han_1]
  dec al
  jz @@next_1
  les bx, [han_font_1]
  call put_font_multi_han, si, di, bx, es, [word start_color]
 @@next_1:
  mov al, [han_2]
  dec al
  dec al
  jz @@next_2
  les bx, [han_font_2]
  call put_font_multi_han, si, di, bx, es, [word start_color]
 @@next_2:
  mov al, [han_3]
  dec al
  jz @@exit
  les bx, [han_font_3]
  call put_font_multi_han, si, di, bx, es, [word start_color]

 @@exit:
  ret
endp
global put_char_multi_han : proc


;***************************
;  Ðe ¢…¸a· µw´áŸi ¿¢“e”a.
;***************************
proc put_char_multi_eng  x:word, y:word, code:byte, start_color:byte
  uses es, si, di

  mov al, [code]
  cmp al, '!'
  jb @@exit
  sub al, '!'
  xor ah, ah
  shl ax, 4     ; ax *= 16

  mov bx, offset _english
  add bx, ax
  call put_font_multi_eng, [x], [y], bx, ds, [word start_color]

 @@exit:
  ret
endp
global put_char_multi_eng : proc


END
