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

  _message_delay  dw NO_DELAY


CODESEG

;********************
;  ¢…¸aµi·i  e—e”a.
; void make_str( int x, int y, char *str_data, byte color )
;********************
proc make_str  x:word, y:word, str_data:dword, color:byte
  local org_x:word
  uses es, si

  mov ax, [x]
  mov [org_x], ax

  les si, [str_data]

 @@loop:
  mov ax, [es:si]
  xchg ah, al
  cmp ah, 00h    ; ah == '\0' ?
  je @@exit

  test ah, 10000000b
  jz @@test_eng

  call put_char_han, [x], [y], ax, [word color]
  add [x], 16
  inc si
  jmp @@test_delay

 @@test_eng:
  cmp ah, 0Ah    ; ah == '\n' ?
  jne @@eng
  mov ax, [org_x]
  mov [x], ax
  add [y], 18
  jmp @@test_delay

 @@eng:
  mov al, ah
  call put_char_eng, [x], [y], ax, [word color]
  add [x], 8

 @@test_delay:
  or [_message_delay], 0
  jz @@no_delay
  call delay_program, [_message_delay]
 @@no_delay:
  inc si
  jmp @@loop

 @@exit:
  ret
endp
global make_str : proc


;*************************************
; ·³ÁAˆq·i º´á¬á ¡A­A»¡Ÿi Îa¯¡Ðe”a.
; void make_str_double( int x, int y, char *str_data, byte color, word high )
;*************************************
proc make_str_double  x:word, y:word, str_data:dword, color:byte, high:word
  local org_x:word
  uses es, si, di

  mov ax, [x]
  mov [org_x], ax

  les si, [str_data]

 @@loop:
  mov cx, [x]
  add cx, [high]
  mov dx, [y]
  add dx, [high]

  mov ax, [es:si]
  xchg ah, al
  mov di, ax
  cmp ah, 00h    ; ah == '\0' ?
  je @@exit

  test ah, 10000000b
  jz @@test_eng

  call put_char_han, cx, dx, di, [word _attr_shadow_color]
  call put_char_han, [x], [y], di, [word color]
  add [x], 16
  inc si
  jmp @@test_delay

 @@test_eng:
  cmp ah, 0Ah    ; ah == '\n' ?
  jne @@eng
  mov ax, [org_x]
  mov [x], ax
  add [y], 18
  jmp @@test_delay

 @@eng:
  mov al, ah
  mov di, ax
  call put_char_eng, cx, dx, di, [word _attr_shadow_color]
  call put_char_eng, [x], [y], di, [word color]
  add [x], 8

 @@test_delay:
  or [_message_delay], 0
  jz @@no_delay
  call delay_program, [_message_delay]
 @@no_delay:
  inc si
  jmp @@loop

 @@exit:
  ret
endp
global make_str_double : proc


;**********************************
; ¢…¸aµi·i  e—e”a. ( éË¡ Äéœá¡)
; void make_str_multi( int x, int y, char *str_data, byte start_color )
;**********************************
proc make_str_multi  x:word, y:word, str_data:dword, start_color:byte
  local org_x:word
  uses es, si

  mov ax, [x]
  mov [org_x], ax

  les si, [str_data]

 @@loop:
  mov ax, [es:si]
  xchg ah, al
  cmp ah, 00h    ; ah == '\0' ?
  je @@exit

  test ah, 10000000b
  jz @@test_eng

  call put_char_multi_han, [x], [y], ax, [word start_color]
  add [x], 16
  inc si
  jmp @@test_delay

 @@test_eng:
  cmp ah, 0Ah    ; ah == '\n' ?
  jne @@eng
  mov ax, [org_x]
  mov [x], ax
  add [y], 18
  jmp @@test_delay

 @@eng:
  mov al, ah
  call put_char_multi_eng, [x], [y], ax, [word start_color]
  add [x], 8

 @@test_delay:
  or [_message_delay], 0
  jz @@no_delay
  call delay_program, [_message_delay]
 @@no_delay:
  inc si
  jmp @@loop

 @@exit:
  ret
endp
global make_str_multi : proc


END
