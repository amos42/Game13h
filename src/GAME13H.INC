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
P286N
MODEL Large, C
DOSSEG

include "game13h.mac"


  GRAPH_SEG    = 0A000h

  H_RES = 320d
  V_RES = 200d
  MAX_X = (H_RES - 1)
  MAX_Y = (V_RES - 1)

  BLACK        = 0
  BLUE         = 1
  GREEN        = 2
  CYAN         = 3
  RED          = 4
  MAGENTA      = 5
  BROWN        = 6
  LIGHTGRAY    = 7
  DARKGRAY     = 8
  LIGHTBLUE    = 9
  LIGHTGREEN   = 10
  LIGHTCYAN    = 11
  LIGHTRED     = 12
  LIGHTMAGENTA = 13
  YELLOW       = 14
  WHITE        = 15

  _ESC           = 1Bh
  _SPACE         = 20h
  _ENTER         = 0Dh
  _TAB           = 09h
  _UP_LEFT       = 4700h
  _UP            = 4800h
  _UP_RIGHT      = 4900h
  _LEFT          = 4B00h
  _RIGHT         = 4D00h
  _DOWN_LEFT     = 4F00h
  _DOWN          = 5000h
  _DOWN_RIGHT    = 5100h
  _ALT_X         = 2D00h
  _F1            = 3B00h
  _F10           = 4400h
  _PG_UP         = _UP_RIGHT
  _PG_DN         = _DOWN_RIGHT
  _HOME          = _UP_LEFT
  _END           = _DOWN_LEFT

  PALETTE_READ   = 03C7h
  PALETTE_WRITE  = 03C8h
  PALETTE_DATA   = 03C9h

  TRUE   = 1
  FALSE  = 0
  ON     = 1
  OFF    = 0
  NO_SKIP  = 0
  NO_DELAY = 0

  NULL   = 0
  CANCEL = -1

struc procedure
  reg_ip   dw ?
  reg_cs   dw ?
ends


;****************
;  ‰·¶w žË¥—i
;****************
global null_function       : proc
global init_game13h        : proc
global close_game13h       : proc
global set_monitor         : proc
global set_clip_window     : proc
global delay_program       : proc
global get_word            : proc
global get_dword           : proc
global xchg_hl             : proc
global int_to_char         : proc

global _attr_shadow_color  : byte
global _attr_back_color    : byte
global _attr_null_color    : byte
global _min_x, _max_x, _min_y, _max_y : word


;*************************
;    ‹aœÏ¢ ÀáŸ¡ Ðq®—i
;*************************
struc picture_header
  head_id  db "Game13h Picture", 0
  ver      db 1
  number   db 1
  offset   dd 64 dup(18)
ends

struc pic_chunk_head
  size     dw 0
  rle_flag db 1
  pal_flag db 0
ends

global clear_screen        : proc
global get_pixel           : proc
global put_pixel           : proc
global put_pixel_xor       : proc
global line                : proc
global line_horiz          : proc
global line_vert           : proc
global line_cross          : proc
global box                 : proc
global box_xor             : proc
global bar                 : proc
global bar_xor             : proc
global bar_shade           : proc
global incode_picture      : proc
global decode_picture      : proc
global load_picture        : proc
global tv_noise            : proc
global tv_noise_clip       : proc
global scroll_up           : proc
global scroll_down         : proc
global scroll_left         : proc
global scroll_right        : proc
global scroll              : proc
global scroll_clear        : proc
global scroll_up_screen    : proc
global scroll_down_screen  : proc
global rotate              : proc


;********************
;  ¶å•¡¶ ‰Åe Ðq®
;********************
struc window_header
  head_id  db "Game13h Window_", 0
  ver      db 1
ends

global draw_window         : proc
global open_window         : proc
global center_window       : proc
global load_user_window    : proc
global draw_user_window    : proc
global open_user_window    : proc
global center_user_window  : proc
global close_window        : proc


;************************
;   ÍA·¡»¡ ‰Åe Ðq®—i
;************************
global init_page           : proc
global page_pointer        : proc
global close_page          : proc
global copy_page           : proc
global copy_page_char      : proc
global copy_page_char_horiz: proc
global activity_page       : proc
global activity_page_step  : proc
global copy_page_horiz     : proc
global copy_page_cut       : proc
global copy_page_move      : proc

global _page_number      : word
global _screen_page      : word : 4
global _last_page_number : word


;************************
;   ·¡£¡»¡ ‰Åe Ðq®—i
;************************
struc image_header
  head_id  db "Game13h Image__", 0
  ver      db 1
  number   db 0
  offset   dd 64 dup(18)
ends

global get_image           : proc
global get_image_fix       : proc
global image_size          : proc
global image_size_xy       : proc
global image_scale         : proc
global image_copy          : proc
global image_translate     : proc
global image_flip_horiz    : proc
global image_flip_vert     : proc
global image_flip_both     : proc
global image_zoom          : proc
global copy_put            : proc
global copy_put_flip_horiz : proc
global copy_put_flip_vert  : proc
global copy_put_flip_both  : proc
global stencil_put         : proc
global stencil_put_opp     : proc
global char_put            : proc
global char_put_flip_horiz : proc
global char_put_flip_vert  : proc
global char_put_flip_both  : proc
global char_put_cut        : proc
global char_put_shadow     : proc
global char_put_shade      : proc
global _clipping_y         : proc
global _clipping_x         : proc
global get_image_clip      : proc
global get_image_fix_clip  : proc
global copy_put_clip_y     : proc
global copy_put_clip_x     : proc
global copy_put_clip       : proc
global char_put_clip_y     : proc
global char_put_clip_x     : proc
global char_put_clip       : proc
global char_put_shadow_clip: proc
global char_put_shade_clip : proc
global load_image          : proc
global load_icon           : proc
global free_icon           : proc


;**************************
;    ÌiAËa ‰Åe Ðq®—i
;**************************
struc palette_data
   red   db ?
   green db ?
   blue  db ?
ends

struc palette_header
  head_id  db "Game13h Palette", 0
  ver      db 1
  number   db 0
ends

global get_palette         : proc
global set_palette         : proc
global fix_palette         : proc
global fix_palette_array   : proc
global recover_palette     : proc
global all_palette         : proc
global change_palette      : proc
global change_palette_part : proc
global fade_out            : proc
global fade_out_part       : proc
global fade_out_step       : proc
global fade_out_rgb        : proc
global fade_in             : proc
global fade_in_part        : proc
global fade_in_step        : proc
global fade_in_rgb         : proc
global fade_change         : proc
global fade_change_par     : proc
global fade_change_step    : proc
global cycle_palette       : proc
global set_cycle           : proc
global reset_cycle         : proc
global gray_palette        : proc
global gray_palette_array  : proc
global load_palette        : proc
global load_overlab        : proc

global _palette             : palette_data
global _change_palette_flag : word
global _use_cycle_palette   : word


;**************************
;  Ðe‹i Â‰b ‰Åe Ðq®—i
;**************************
global load_font           : proc
global load_font_user_han  : proc
global load_font_user_eng  : proc
global put_font_eng        : proc
global put_font_han        : proc
global put_font_multi_eng  : proc
global put_font_multi_han  : proc
global put_char_han        : proc
global put_char_eng        : proc
global put_char_multi_han  : proc
global put_char_multi_eng  : proc
global make_str            : proc
global make_str_multi      : proc
global make_str_double     : proc
global make_message        : proc
global input_string        : proc
global make_str_small      : proc

global _message_delay : word
global _hangul1       : word
global _hangul2       : word
global _hangul3       : word
global _english       : byte
global _special       : byte


;************************
;  ·³b¸wÃ¡ ‰Åe Ðq®—i
;************************
MOUSE_MOVE    = 0
LEFT_CLICK    = 1
RIGHT_CLICK   = 2
DOUBLE_CLICK  = 3
ALL_CLICK     = 4
MOUSE_DRAG    = 5

struc multi_key_data
  press  dw  ?
  scan   db  128 dup(?)
  last   db  ?
ends

struc mouse_point_data
  x                   dw 0
  y                   dw 0
  display_cursor      dw FALSE
  double_click_speed  dw 3
  move                dw FALSE
  left                dw FALSE
  right               dw FALSE
  double_click        dw FALSE
  drag                dw FALSE
ends

global set_multi_key       : proc
global reset_multi_key     : proc
global clear_key           : proc
global get_key             : proc
global put_key             : proc
global action_key          : proc
global delay_key           : proc

global get_joy_stick       : proc
global get_joy_button      : proc

global init_mouse          : proc
global close_mouse         : proc
global set_mouse_window    : proc
global set_mouse_cursor    : proc
global set_mouse_mickey    : proc
global set_mouse_speed     : proc
global mouse_cursor_on     : proc
global mouse_cursor_off    : proc
global state_mouse         : proc
global get_mouse_button    : proc
global locate_mouse_cursor : proc
global check_mouse         : proc

global _key           : multi_key_data
global _use_multi_key : word
global _mouse         : mouse_point_data
global _use_mouse     : word
global _user_handle   : dword : 6


;*************************
;  ·q¬÷ Â‰b ‰Åe Ðq®—i
;*************************
NO_VOICE   = 0
PC_SPEAKER = 1
S_BLASTER  = 2

struc voice_data
  length          dw 0
  ptr             dd 0
  linear_addr     dd 0
ends

struc sb_state
  io_addr         dw 220h
  irq             db 7
  dma_channel     db 1
ends

global init_voice          : proc
global load_voice          : proc
global free_voice          : proc
global sample_rate         : proc
global stop_voice          : proc
global continue_voice      : proc
global speaker_on          : proc
global speaker_off         : proc

global _sound_device   : word
global _sb_io_addr     : sb_state
global _voice_flag     : word


;**********************
;  FLI Â‰b ‰Åe ÑA”á
;**********************
struc fli_state
  frame    dw  0
  stop     dd  0
  before   dd  0
  after    dd  0
ends

global fli_play            : proc

global _fli    : fli_state


;*********************
;   MIDI· ÑA”á ÑÁ·©
;*********************
global init_midi           : proc
global play_midi           : proc
global music_position      : proc
global set_music_volume    : proc
global stop_music          : proc
global close_midi          : proc

global _playing_flag       : word


;**********************
;    XMS ‰Åe ÑA”á
;**********************
FREE_SIZE     = 0
LARGEST_SIZE  = 1

global xms_install         : proc
global xms_size            : proc
global xms_alloc           : proc
global xms_realloc         : proc
global xms_free            : proc
global xms_lock            : proc
global xms_unlock          : proc
global xms_push            : proc
global xms_pop             : proc
global store_screen        : proc
global restore_screen      : proc
global store_image         : proc
global restore_image       : proc


;***********************
;   UTIL.C· ÑA”á ÑÁ·©
;***********************
global yes_or_no           : proc
global index_cursor        : proc
global select_icon         : proc
global reply_quit          : proc
global get_exec_path       : proc
global str                 : proc
global str_hex             : proc

global gen_menu            : proc
global gen_menu_small      : proc

global draw_button         : proc
global push_button         : proc
global release_button      : proc

