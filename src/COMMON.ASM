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

  _attr_shadow_color db BLACK
  _attr_back_color   db BLACK
  _attr_null_color   db 255

  _min_x dw 0
  _min_y dw 0
  _max_x dw MAX_X
  _max_y dw MAX_Y

  _page_number      dw 0
  _screen_page      dw GRAPH_SEG, GRAPH_SEG, GRAPH_SEG, GRAPH_SEG


CODESEG

;**************************
;  ´a¢ˆõ•¡ Ða»¡ ´g“e Ðq®
; void null_function(void)
;**************************
proc null_function
  ret
endp
global null_function : proc


;************************
;  Game13hŸi Á¡‹¡ÑÁÐe”a.
; void init_game13h(void)
;************************
proc init_game13h
  mov ax, 0013h
  int 10h

  call recover_palette

  ret
endp
global init_game13h : proc


;**********************
;  Game13hŸi ¹AˆáÐe”a.
; void close_game13h(void)
;**********************
proc close_game13h
  mov ax, 0003h
  int 10h

  ; ‹a”¡ {¡e ¹½»¡ ´g·e žË¥·i ¹aˆáÐe”a.
  _if_zero [_use_mouse], @@no_mouse
    call close_mouse
 @@no_mouse:
  _if_zero [_use_multi_key], @@no_multi_key
    call reset_multi_key
 @@no_multi_key:

  ret
endp
global close_game13h : proc


;***********************
;  ¡¡“¡ÈáŸi On/OffÐe”a.
; void set_monitor( int state )
;***********************
proc set_monitor  state : word
  mov ax, [state]
  test ax, ax
  jz @@off
  xor al, al
  jmp @@on

 @@off:
  mov al, 1

 @@on:
  mov ah, 12h
  mov bl, 36h
  int 10h

  ret
endp
global set_monitor : proc


;***************************************
;  ·¡£¡»¡, ‹aœÏ¢· ÇiŸ¡Ï· ¶å•¡¶ ¬é¸÷
; void set_clip_window( int start_x, int start_y, int end_x, int end_y )
;***************************************
proc set_clip_window  start_x:word, start_y:word, end_x:word, end_y:word
  mov ax, [start_x]
  mov [_min_x], ax
  mov ax, [start_y]
  mov [_min_y], ax

  mov ax, [end_x]
  mov [_max_x], ax
  mov ax, [end_y]
  mov [_max_y], ax

  ret
endp
global set_clip_window : proc


;************************************************
;  Ïa¡‹aœ‘· ¯©Ð—·i 1/1000Á¡ ”e¶á¡ »¡µe¯¡Ç¥”a.
; void delay_program( word milli_sec )
;************************************************
proc delay_program  milli_sec:word
  mov ax, 1000d
  mul [milli_sec]
  mov cx, dx
  mov dx, ax

  mov ah, 86h
  int 15h

  ret
endp
global delay_program : proc


;******************************************
;  ¶¡—a •a·¡Èá· ¬wÐa¶á ¤a·¡ËaŸi ŠaÑÅÐe”a.
; int xchg_hl( int data )
;******************************************
proc xchg_hl  data:word
  mov ax, [data]
  xchg al, ah

  ret
endp
global xchg_hl : proc


END
