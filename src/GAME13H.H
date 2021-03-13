/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                    Ðeq ”ÐbŠa ®Ðb‰Á
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/

#ifndef __LARGE__
#  ifndef __HUGE__
#    error This library will not compile in this memory model.
#  endif
#endif

#pragma warn -stv

#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <alloc.h>
#include <io.h>
#include <fcntl.h>

#define GRAPH_SEG       0xA000
#define H_RES           320
#define V_RES           200
#define MAX_X           (H_RES - 1)
#define MAX_Y           (V_RES - 1)
#define NO_SKIP         0
#define NO_DELAY        0
#define NULL_COLOR      255

#define TRUE            1
#define FALSE           0
#define CANCEL          -1
#define ON              TRUE
#define OFF             FALSE

#ifndef __COLORS
#define __COLORS
  enum {
    BLACK,    BLUE,      GREEN,      CYAN,      RED,      MAGENTA,      BROWN,  LIGHTGRAY,
    DARKGRAY, LIGHTBLUE, LIGHTGREEN, LIGHTCYAN, LIGHTRED, LIGHTMAGENTA, YELLOW, WHITE
   };
#endif

#define ESC             0x1B
#define SPACE           0x20
#define ENTER           0x0D
#define TAB             0x09
#define UP_LEFT         0x4700
#define UP              0x4800
#define UP_RIGHT        0x4900
#define LEFT            0x4B00
#define RIGHT           0x4D00
#define DOWN_LEFT       0x4F00
#define DOWN            0x5000
#define DOWN_RIGHT      0x5100
#define ALT_X           0x2D00
#define F1              0x3B00
#define F10             0x4400
#define PG_UP           UP_RIGHT
#define PG_DN           DOWN_RIGHT
#define HOME            UP_LEFT
#define END             DOWN_LEFT

typedef unsigned char  byte;
typedef unsigned int   word;
typedef unsigned long  dword;
typedef int            bool;


/************************
       ‰·¶w Ðq®—i
*************************/
void null_function( void );
void init_game13h( void );
void close_game13h( void );
void set_monitor( int state );
void set_clip_window( int start_x, int start_y, int end_x, int end_y );
void delay_program( word milli_sec );
word get_word( char *ptr );
dword get_dword( char *ptr );
int  xchg_hl( int data );
void char_to_int( char char_high, char char_low, int *integer );
void int_to_char( int integer, char *char_high, char *char_low );

extern byte _attr_shadow_color;
extern byte _attr_back_color;
extern byte _attr_null_color;
extern int _min_x, _max_x, _min_y, _max_y;


/************************
    ‹aœÏ¢ ÀáŸ¡ Ðq®—i
*************************/
struct picture_header {
         char head_id[15 + 1];
         byte ver;
         byte number;
         dword offset[64];
        };

struct pic_chunk_head {
         word size;
         char rle_flag;
         char pal_flag;
        };

void clear_screen( byte color );
byte get_pixel( int x, int y );
void put_pixel( int x, int y, byte color );
void put_pixel_xor( int x, int y );
void line( int start_x, int start_y, int end_x, int end_y, byte color );
void line_horiz( int x, int y, word length, byte color );
void line_vert( int x, int y, word length, byte color );
void line_cross( int x, int y, word length, byte color );
void box( int start_x, int start_y, int end_x, int end_y, byte color );
void box_xor( int start_x, int start_y, int end_x, int end_y );
void bar( int start_x, int start_y, int end_x, int end_y, byte color );
void bar_xor( int start_x, int start_y, int end_x, int end_y );
void bar_shade( int start_x, int start_y, int end_x, int end_y, char shade );
word incode_picture( char **data, byte page );
void decode_picture( char *data, byte page );
int  load_picture( char *file_name, word pic_number );
void tv_noise( void );
void tv_noise_clip( void );
void scroll_up( int start_x, int start_y, int end_x, int end_y, word step );
void scroll_down( int start_x, int start_y, int end_x, int end_y, word step );
void scroll_left( int start_x, int start_y, int end_x, int end_y, word step );
void scroll_right( int start_x, int start_y, int end_x, int end_y, word step );
void scroll( int start_x, int start_y, int end_x, int end_y, char direct, word step );
void scroll_clear( int s_x, int s_y, int e_x, int e_y, char direct, word step );
void scroll_up_screen( word step );
void scroll_down_screen( word step );
void rotate( int start_x, int start_y, int end_x, int end_y, char direct, word step );


/***********************
   ÍA·¡»¡ ‰Åe Ðq®—i
************************/
int  init_page( word add_page );
char *page_pointer( word page );
void close_page( void );
void copy_page( word source_page, word target_page );
void copy_page_char(word source_page, word target_page, int s_x, int s_y, int e_x, int e_y);
void copy_page_char_horiz( word source_page, word target_page, int start_y, int end_y );
void activity_page( word page );
void activity_page_step( word page, word skip_line, word milli_sec );
void copy_page_horiz( word source_page, word target_page, int start_y, int end_y );
void copy_page_cut( word source_page, word target_page, int s_x, int s_y, int e_x, int e_y );
void copy_page_move(word source_page, word target_page, int s_x, int s_y, int e_x, int e_y, int t_x, int t_y);

extern word _page_number;
extern word _screen_page[4];
extern word _last_page_number;


/************************
   ·¡£¡»¡ ‰Åe Ðq®—i
*************************/
struct image_header {
         char head_id[15 + 1];
         byte ver;
         byte number;
         dword offset[64];
        };
typedef char* image_data;

struct icon_header {
         char head_id[15 + 1];
         byte ver;
         byte number;
         int size_x, size_y;
        };

typedef struct {
         int number;
         int size_x, size_y;
         image_data *icon;
      } icon_data;

void get_image( int start_x, int start_y, int end_x, int end_y, image_data *image );
void get_image_fix( int start_x, int start_y, int end_x, int end_y, image_data image );
word image_size( image_data image );
void image_size_xy( image_data image, word *x, word *y );
void image_scale( int x, int y, image_data original_image, word scale_x, word scale_y );
void image_copy( image_data source_image, image_data *target_image );
void image_translate( image_data source_image, image_data *target_image, char tran );
void image_flip_horiz( image_data source_image, image_data *target_image );
void image_flip_vert( image_data source_image, image_data *target_image );
void image_flip_both( image_data source_image, image_data *target_image );
void image_zoom( image_data source_image, image_data *target_image, word new_x, word new_y );
void copy_put( int x, int y, image_data image );
void copy_put_flip_horiz( int x, int y, image_data image );
void copy_put_flip_vert( int x, int y, image_data image );
void copy_put_flip_both( int x, int y, image_data image );
void stencil_put( int x, int y, image_data image, byte stencil );
void stencil_put_opp( int x, int y, image_data image, byte opp_stencil );
void char_put( int x, int y, image_data image );
void char_put_flip_horiz( int x, int y, image_data image );
void char_put_flip_vert( int x, int y, image_data image );
void char_put_flip_both( int x, int y, image_data image );
void char_put_cut( int x, int y, image_data image, int skip_x, int skip_y, word length_x, word length_y );
void char_put_shadow( int x, int y, image_data image );
void char_put_shade( int x, int y, image_data image, char shade );
void _clipping_y( void );
void _clipping_x( void );
void get_image_clip( int start_x, int start_y, int end_x, int end_y, image_data *image );
void get_image_fix_clip( int start_x, int start_y, int end_x, int end_y, image_data image );
void copy_put_clip_y( int x, int y, image_data image );
void copy_put_clip_x( int x, int y, image_data image );
void copy_put_clip( int x, int y, image_data image );
void char_put_clip_y( int x, int y, image_data image );
void char_put_clip_x( int x, int y, image_data image );
void char_put_clip( int x, int y, image_data image );
void char_put_shadow_clip( int x, int y, image_data image );
void char_put_shade_clip( int x, int y, image_data image, char shade );
int  load_image( char *file_name, image_data *image, word image_number );
int  load_icon( char *file_name, icon_data *icon, word start, word icon_number );
void free_icon( icon_data *icon );


/********************
  ¶å•¡¶ ‰Åe Ðq®
*********************/
struct window_header {
         char head_id[15 + 1];
         byte ver;
        };

typedef struct {
         int x, y;
         image_data image;
        } window_data;

int  draw_window( int start_x, int start_y, int end_x, int end_y );
int  open_window( int start_x, int start_y, int end_x, int end_y, window_data *window );
int  center_window( word size_x, word size_y, window_data *window );
int  load_user_window( char *file_name );
int  draw_user_window( int x, int y, word size_x, word size_y );
int  open_user_window( int x, int y, word size_x, word size_y, window_data *window );
int  center_user_window( word size_x, word size_y, window_data *window );
void close_window( window_data *window );

/**************************
    ÌiAËa ‰Åe Ðq®—i
***************************/
#define S_CYCLE         0xE0
#define E_CYCLE         0xE7

typedef struct { char red, green, blue; } palette_data;

struct palette_header {
         char head_id[15 + 1];
         byte ver;
         byte number;
        };

struct overlab_header {
         char head_id[15 + 1];
         byte ver;
         word pic_size;
         char rle_flag;
        };

palette_data get_palette( byte color_no );
void set_palette( byte color_no, char red, char green, char blue );
void fix_palette( void );
void fix_palette_array( palette_data *array, byte start_color, word change );
void recover_palette( void );
void all_palette( byte color );
void change_palette( palette_data *palette_info );
void change_palette_part( palette_data *palette_info, byte start_color, word change );
void fade_out( byte target_color, word step, word milli_sec );
void fade_out_part( byte target_color, word step, word milli_sec, byte start, word change );
void fade_out_step( byte target_color, word step );
void fade_out_rgb( byte red, byte green, byte blue, word step, word milli_sec );
void fade_in( byte source_color, word step, word milli_sec );
void fade_in_part( byte source_color, word step, word milli_sec, byte start, word change );
void fade_in_step( byte source_color, word step );
void fade_in_rgb( byte red, byte green, byte blue, word step, word milli_sec );
void fade_change( palette_data *source, palette_data *target, word step, word milli_sec );
void fade_change_part(palette_data *source, palette_data *target, word step, word milli_sec, byte start, word change);
void fade_change_step( palette_data *source, palette_data *target, word step );
void cycle_palette( byte start_color, byte end_color );
void set_cycle( byte start_color, byte end_color, word delay_time );
void reset_cycle( void );
void gray_palette( word gray_color );
void gray_palette_array( word gray_color, palette_data *pal_array );
int  load_palette( char *file_name, word pal_number );
int  load_overlab( char *file_name, word page, palette_data *pal_1, palette_data *pal_2 );

extern palette_data _palette[256];
extern bool _change_palette_flag;
extern bool _use_cycle_palette;


/*************************
  Ðe‹i Â‰b ‰Åe Ðq®—i
**************************/
enum { H_NULL, H_GT, H_MJ, H_PI };
enum { E_NULL, E_GT, E_MJ, E_IT, E_OB };

int  load_font( int han_font, int eng_font, char *path );
int  load_font_user_han( char *file_name );
int  load_font_user_eng( char *file_name );
void put_font_eng( int x, int y, byte *chr, byte color );
void put_font_han( int x, int y, word *chr, byte color );
void put_font_multi_eng( int x, int y, byte *chr, byte start_color );
void put_font_multi_han( int x, int y, word *chr, byte start_color );
void put_char_han( int x, int y, int code, byte color );
void put_char_eng( int x, int y, char code, byte color );
void put_char_multi_han( int x, int y, int code, byte color );
void put_char_multi_eng( int x, int y, char code, byte color );
void make_str( int x, int y, char *str_data, byte color );
void make_str_multi( int x, int y, char *str_data, byte start_color );
void make_str_double( int x, int y, char *str_data, byte color, int high );
int  make_message( char *message[], word row );
int  input_string( int x, int y, char *str, byte color, word length );
void make_str_small( int x, int y, char *str_data, byte color );

extern word _message_delay;
extern word _hangul1[6][19][16], _hangul2[2][21][16], _hangul3[28][16];
extern byte _english[94][16], _special[14][16];


/***********************
  ·³b¸wÃ¡ ‰Åe Ðq®—i
************************/
struct multi_key_data {
  word press;
  byte scan[128];
  byte last;
 };

struct mouse_point_data {
  int  x, y;
  bool display_cursor;
  word double_click_speed;
  bool move;
  bool left;
  bool right;
  bool double_click;
  bool drag;
};

#define MOUSE_MOVE    0
#define LEFT_CLICK    1
#define RIGHT_CLICK   2
#define DOUBLE_CLICK  3
#define ALL_CLICK     4
#define MOUSE_DRAG    5

void set_multi_key( void );
void reset_multi_key( void );
void clear_key( void );
int  get_key( void );
void put_key( int key );
int  action_key( void );
void delay_key( void );

void get_joy_stick( int *x, int *y );
int  get_joy_button( void );

int  init_mouse( void );
void close_mouse( void );
void set_mouse_window( int start_x, int start_y, int end_x, int end_y );
void set_mouse_cursor( image_data cursor_data );
void set_mouse_mickey( word x_mickey, word y_mickey );
void set_mouse_speed( word x, word y, word double_speed );
void mouse_cursor_on( void );
void mouse_cursor_off( void );
int  state_mouse( int *x, int *y );
bool get_mouse_button( int button );
void locate_mouse_cursor( int x, int y );
bool check_mouse( int start_x, int start_y, int end_x, int end_y );

extern struct multi_key_data _key;
extern bool _use_multi_key;
extern struct mouse_point_data _mouse;
extern bool _use_mouse;
extern void (*_user_handle[6])( void );


/************************
  ·q¬÷ Â‰b ‰Åe Ðq®—i
*************************/
#define NO_VOICE   0
#define PC_SPEAKER 1
#define S_BLASTER  2

typedef struct {
          word length;
          char *ptr;
          long linear_addr;
        } voice_data;

struct sb_state {
          int  io_addr;
          byte irq;
          byte dma_channel;
        };

void init_voice( int sound_dev );
int  load_voice( char *file_name, voice_data *data );
void free_voice( voice_data *data );
void sample_rate( word rate );  /* SB Only */
void stop_voice( void );

extern void (*output_voice)( voice_data data );
extern void (*close_voice)( void );
extern int _sound_device;

extern struct sb_state _sb;
extern bool _voice_flag;


/*********************
  FLI Â‰b ‰Åe ÑA”á
**********************/
typedef struct {
      dword size;
      word  type;
      word  frame_count;
      word  width;
      word  height;
      word  bit_per_pixel;
      int   flags;
      int   speed;
      long  next_head;
      dword frames_in_table;
      int   file;
      dword frame_1_off;
      dword strokes;
      dword session;
      char  unused[88];
     } fli_header_type;

struct fli_state {
      word _frame;
      bool (*stop)(void);
      void (*before)(void), (*after)(void);
    };

int  fli_play( char *fli_name, char mode );

extern fli_header_type _fli_head;
extern struct fli_state _fli;


/*********************
   MIDI· ÑA”á ÑÁ·©
**********************/
void init_midi( void );
int  play_midi( char *file_name );
dword music_position( void );
void set_music_volume( word volume );
void stop_music( void );
void close_midi( void );

extern bool _playing_flag;


/**********************
    XMS ‰Åe ÑA”á
***********************/
#define FREE_SIZE    0
#define LARGEST_SIZE 1

int  xms_install( void );
int  xms_size( int option );
int  xms_alloc( word size );
int  xms_realloc( int handle, word new_size );
int  xms_free( int handle );
int  xms_lock( int handle, long *linear_addr );
int  xms_unlock( int handle );
int  xms_push( int handle, char *data, dword length );
int  xms_pop( int handle, char *data, dword length );
int  store_screen( word page );
void restore_screen( int handle, word page );
int  store_image( image_data image );
void restore_image( int handle, image_data *image );


/***********************
   UTIL.C· ÑA”á ÑÁ·©
************************/
typedef struct {
          int start_x, start_y;
          int end_x, end_y;
          bool push_flag;
         } button_data;

bool yes_or_no( void );
void index_cursor( int x, int y, byte color );
int  select_icon( icon_data icon, word disp );
bool reply_quit( void );
void get_exec_path( char *path );
char *str( int number );
char *str_hex( int number );

int  gen_menu( char *message[], int max_row, int disp_row );
int  gen_menu_small( char *message[], int max_row, int disp_row );

void draw_button( int start_x, int start_y, int end_x, int end_y, button_data *button );
void push_button( button_data *button );
void release_button( button_data *button );

