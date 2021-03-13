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

  _user_handle         dd 6 dup(?)
  mouse_back           db 256+4 dup(?)


DATASEG

  _use_mouse           dw FALSE
  _mouse mouse_point_data <>

  old_click            dw 0
  double_flag          dw FALSE

  mouse_image          dw 16, 16
        dw  0000h, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0F00h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  1800h,  000Fh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0F07h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0707h,  000Fh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0707h,  0F07h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0707h,  0707h,  000Fh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0707h,  0707h,  0F07h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0707h,  0707h,  0808h,  000Fh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0807h,  0F08h,  0000h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h,  0008h,  0F08h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0800h, 0FF00h,  0800h,  000Fh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw  0000h, 0FFFFh,  0800h,  000Fh, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh
        dw 0FFFFh, 0FFFFh,  00FFh,  0F08h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh
        dw 0FFFFh, 0FFFFh,  00FFh,  0808h, 0FF00h, 0FFFFh, 0FFFFh, 0FFFFh
        dw 0FFFFh, 0FFFFh, 0FFFFh,  0000h, 0FFFFh, 0FFFFh, 0FFFFh, 0FFFFh


CODESEG

;*******************
;  ‹¡¥¥¸â·¥ Ð…—iœá
;*******************
proc public_handle
  local event, x, y, button : word
  uses ds, es

;  cli

  mov [event], ax
  mov [button], bx
  shr cx, 1
  mov [x], cx
  mov [y], dx

  push DGROUP
  pop ds

  cmp cx, [_mouse.x]
  jne @@move
  cmp dx, [_mouse.y]
  jne @@move
  mov [_mouse.move], FALSE
  mov [_mouse.drag], FALSE
  jmp @@button

 @@move:
  mov [_mouse.move], TRUE
  mov [_mouse.double_click], FALSE
  mov [double_flag], FALSE
  _if_zero [button], @@display
    mov [_mouse.drag], TRUE

    mov ax, [word high _user_handle + 5*4]
    or  ax, [word low  _user_handle + 5*4]
    jz @@no_5
    call [_user_handle + 5*4]
    @@no_5:

 @@display:
  _if_zero [_mouse.display_cursor], @@set_squre
    call copy_put, [_mouse.x], [_mouse.y], offset mouse_back, ds

    push [_page_number]
    mov [_page_number], 0

    mov ax, [x]
    add ax, 15
    mov bx, [y]
    add bx, 15
    call get_image_fix_clip, [x], [y], ax, bx, offset mouse_back, ds

    call char_put_clip, [x], [y], offset mouse_image, ds

    pop [_page_number]

 @@set_squre:
  mov ax, [x]
  mov [_mouse.x], ax
  mov ax, [y]
  mov [_mouse.y], ax

  mov ax, [word high _user_handle + 0*4]
  or  ax, [word low  _user_handle + 0*4]
  jz @@button
  call [_user_handle + 0*4]

 @@button:
  cmp [button], 1
  jne @@check_2
    mov [_mouse.left], TRUE

    mov ax, [word high _user_handle + 1*4]
    or  ax, [word low  _user_handle + 1*4]
    jz @@no_1
    call [_user_handle + 1*4]
    @@no_1:

    _if_zero [double_flag], @@no_double
      mov ax, 40h
      mov es, ax
      mov ax, [es:6Ch]   ; Timer 0040:006Ch
      sub ax, [old_click]
      cmp ax, [_mouse.double_click_speed]
      jge @@no_double
      mov [_mouse.double_click], TRUE

      mov ax, [word high _user_handle + 4*4]
      or  ax, [word low  _user_handle + 4*4]
      jz @@no_double
      call [_user_handle + 4*4]
    @@no_double:
    mov [double_flag], TRUE
    jmp @@exit

 @@check_2:
  cmp [button], 2
  jne @@check_3
    mov [_mouse.right], TRUE

    mov ax, [word high _user_handle + 2*4]
    or  ax, [word low  _user_handle + 2*4]
    jz @@no_2
    call [_user_handle + 2*4]
    @@no_2:

    jmp @@exit

 @@check_3:
  cmp [button], 3
  jne @@check_double_and_move
    mov [_mouse.right], TRUE

    mov ax, [word high _user_handle + 3*4]
    or  ax, [word low  _user_handle + 3*4]
    jz @@no_3
    call [_user_handle + 3*4]
    @@no_3:

    jmp @@exit

 @@check_double_and_move:
  mov [_mouse.left], FALSE
  mov [_mouse.right], FALSE
  mov [_mouse.double_click], FALSE
  mov [_mouse.drag], FALSE
  _if_zero [double_flag], @@exit
    _if_not_zero [_mouse.move], @@exit
      mov ax, 40h
      mov es, ax
      mov ax, [es:6Ch]   ; Timer 0040:006Ch
      mov [old_click], ax

 @@exit:
;  sti
  ret
endp


;************************
;   a¶¯aŸi Á¡‹¡ÑÁ Ðe”a.
; int init_mouse(void)
;************************
proc init_mouse
  uses es

  xor bx, bx
  mov cx, 6
 @@init_user_handle:
  mov [word high _user_handle + bx], NULL
  mov [word low  _user_handle + bx], NULL
  add bx, 4
  loop @@init_user_handle

  xor ax, ax
  int 33h       ;  a¶¯a Á¡‹¡ÑÁ

  mov ax, seg public_handle
  mov es, ax
  mov dx, offset public_handle
  mov ax, 0Ch
  mov cx, 00011111b
  int 33h

  mov [_use_mouse], TRUE
  ret
endp
global init_mouse : proc


;***************************
;   a¶¯a Äá¬áŸi ¬é¸÷Ðe”a.
; void set_mouse_cursor( image_data cursor_data )
;***************************
proc set_mouse_cursor  cursor_data:dword
  uses si, di

  push ds
  mov ax, ds
  mov es, ax
  mov di, offset mouse_image
  lds si, [cursor_data]

  mov cx, (256+4)/2
  rep movsw
  pop ds

  _if_zero [_mouse.display_cursor], @@exit
    push [_page_number]
    mov [_page_number], 0

    call copy_put, [_mouse.x], [_mouse.y], offset mouse_back, ds

    mov ax, 3
    int 33h
    shr cx, 1
    mov [_mouse.x], cx
    mov [_mouse.y], dx

    mov si, cx
    add cx, 15
    mov di, dx
    add dx, 15
    call get_image_fix_clip, si, di, cx, dx, offset mouse_back, ds
    call char_put_clip, si, di, offset mouse_image, ds

    pop [_page_number]

 @@exit:
  ret
endp
global set_mouse_cursor : proc


;*********************************
;   a¶¯a Äá¬á· ­¢•¡Ÿi ­AËaÐe”a.
; void set_mouse_mickey( word x_mickey, word y_mickey )
;*********************************
proc set_mouse_mickey  x_mickey:word, y_mickey:word
  mov dx, [x_mickey]
  mov cx, [y_mickey]

  mov ax, 0Fh
  int 33h

  ret
endp
global set_mouse_mickey : proc


;*****************************
;   a¶¯a· ˆq•¡Ÿi ¬é¸÷Ðe”a.
; void set_mouse_speed( word x, word y, word double_speed )
;*****************************
proc set_mouse_speed  x_speed:word, y_speed:word, double_speed:word
  mov bx, [x_speed]
  mov cx, [y_speed]
  mov dx, [double_speed]

  mov ax, 1Ah
  int 33h

  ret
endp
global set_mouse_speed : proc


;*****************************
;   a¶¯a Äá¬áŸi ÑÁ¡eµA Îa¯¡
; void mouse_cursor_on(void)
;*****************************
proc mouse_cursor_on
  uses si, di

  _if_not_zero [_mouse.display_cursor], @@exit

  mov ax, 3
  int 33h
  shr cx, 1
  mov [_mouse.x], cx
  mov [_mouse.y], dx

  push [_page_number]
  mov [_page_number], 0

  mov si, cx
  add cx, 15
  mov di, dx
  add dx, 15
  call get_image_fix_clip, si, di, cx, dx, offset mouse_back, ds
  call char_put_clip, si, di, offset mouse_image, ds

  pop [_page_number]

  mov [_mouse.display_cursor], TRUE

 @@exit:
  ret
endp
global mouse_cursor_on : proc


;*********************************
;   a¶¯a Äá¬áŸi ÑÁ¡eµa¬á »¡¶…”a.
; void mouse_cursor_off(void)
;*********************************
proc mouse_cursor_off
  _if_zero [_mouse.display_cursor], @@exit

  push [_page_number]
  mov [_page_number], 0

  call copy_put, [_mouse.x], [_mouse.y], offset mouse_back, ds

  pop [_page_number]

  mov [_mouse.display_cursor], FALSE

 @@exit:
  ret
endp
global mouse_cursor_off : proc


;**********************
;   a¶¯aŸi ¹aˆáÐe”a.
; void close_mouse(void)
;**********************
proc close_mouse
  xor ax, ax
  int 33h

  call mouse_cursor_off
  mov [_use_mouse], FALSE

  ret
endp
global close_mouse : proc


;***************************************
;   a¶¯a Äá¬á· ¹ÁÎa ¤ñ¶áŸi ¬é¸÷Ðe”a.
; void set_mouse_window( int start_x, int start_y, int end_x, int end_y )
;***************************************
proc set_mouse_window  start_x:word, start_y:word, end_x:word, end_y:word
  mov cx, [start_y]
  cmp cx, [_min_y]
  jge @@skip_1
  mov cx, [_min_y]
 @@skip_1:
  mov dx, [end_y]
  cmp dx, [_max_y]
  jle @@skip_2
  mov dx, [_max_y]
 @@skip_2:
  mov ax, 8
  int 33h

  mov cx, [start_x]
  cmp cx, [_min_x]
  jge @@skip_3
  mov cx, [_min_x]
 @@skip_3:
  mov dx, [end_x]
  cmp dx, [_max_x]
  jle @@skip_4
  mov dx, [_max_x]
 @@skip_4:
  shl cx, 1
  shl dx, 1
  mov ax, 7
  int 33h

  ret
endp
global set_mouse_window : proc


;**********************************************
;   a¶¯a Äá¬á· ¶áÃ¡µÁ ¤áËe· ¬wÈŸi ·ª“e”a.
; int state_mouse( int *x, int *y )
;**********************************************
proc state_mouse  x:dword, y:dword
  uses es

  mov ax, 3
  int 33h

  mov ax, bx
  les bx, [x]
  shr cx, 1
  mov [es:bx], cx
  les bx, [y]
  mov [es:bx], dx

  ret
endp
global state_mouse : proc


;**********************************
;  Ëb¸÷ ¤áËe· ’Ÿq ¬wÈŸi ´è“e”a.
; bool get_mouse_button( int button )
;**********************************
proc get_mouse_button  button:word
  mov ax, 3
  int 33h

  mov cx, [button]
  and bx, cx
  cmp bx, cx
  jne @@no_click

  mov ax, TRUE
  jmp @@exit

 @@no_click:
  xor ax, ax

 @@exit:
  ret
endp
global get_mouse_button : proc


;*******************************************
;  ¶¥Ða“e ¶áÃ¡¡  a¶¯a Äá¬áŸi ·¡•·¯¡Ç¥”a.
; void locate_mouse_cursor( int x, int y )
;*******************************************
proc locate_mouse_cursor  x:word, y:word
  _if_zero [_mouse.display_cursor], @@next

  call mouse_cursor_off

 @@next:
  mov cx, [x]
  shl cx, 1
  mov dx, [y]

  mov ax, 4
  int 33h

  _if_zero [_mouse.display_cursor], @@exit
  call mouse_cursor_on

 @@exit:
  ret
endp
global locate_mouse_cursor : proc


;********************************************
;   a¶¯a Äá¬áˆa »¡¸÷–E ¸w­¡µA ·¶“eˆa Ìe”e.
; bool check_mouse( int start_x, int start_y, int end_x, int end_y )
;********************************************
proc check_mouse  start_x:word, start_y:word, end_x:word, end_y:word
  mov ax, [_mouse.x]
  cmp ax, [start_x]
  jl @@not
  cmp ax, [end_x]
  jg @@not

  mov ax, [_mouse.y]
  cmp ax, [start_y]
  jl @@not
  cmp ax, [end_y]
  jg @@not

  mov ax, TRUE
  jmp @@exit

 @@not:
  xor ax, ax

 @@exit:
  ret
endp
global check_mouse : proc


END
