/***********************************
    GPG ÑÁ·©·i ·¡¶wÐe ICO  e—i‹¡

                 ¹A¸b¸a : º‰w£¥

    File Name : CAP_24.C

 * ‹a¶A ”á Ï©¶aÐe ÑÁ·©;
 GAME13H.H    -- œa·¡§aœáŸ¡· ÑA”á
 GAME13H.LIB
***********************************/
#include <game13h.h>  /*  Ver 4.2  */

#define CTRL_S  0x13
#define CTRL_L  0x0C


char file_name[12 + 1];                 /* Íe»³Ði ÑÁ·©¡w      */
char pic_name[12 + 1];                  /* ‹aŸ±ÑÁ·© ·¡Ÿq      */
image_data temp[99];
icon_data icon = { 0, 24, 24, temp };   /* Í¥ËaŸi ¸á¸wÐi ¤µi */
int x = 0, y = 0;

struct icon_header header = { "Game13h Icon___", 1, 0, 24, 24 };


void click_any_key()
{
  put_key( ENTER );
}

/***********************
  ÑÁ¡e·i Á¡‹¡ÑÁ Ðe”a.
************************/
void init_screen()
{
  char *title[] = { "  13h LBM Capture",
                    "        Ver 1.0",
                    "",
                    "     e—e·¡ : º‰w£¥",
                   };

  init_game13h();
  make_message( title, 4 );
}


/***********************
  ÑÁ·©¡w·i ·³b ¤h“e”a.
************************/
void input_filename()
{
  window_data window;

  center_window( 8*17+15, 16+15, &window );
  make_str_double( window.x + 8, window.y + 8, "ÑÁ·©¡w :", YELLOW, 1 );

  do{
    bar( window.x + 8*9+8, window.y + 8, window.x + 8*17+8, window.y + 16+8, LIGHTGRAY );
    input_string( window.x + 8*9+8, window.y + 8, file_name, WHITE, 8 );
   } while( strlen(file_name) <= 0 );

  strcat( file_name, ".ICO" );

  close_window( &window );
}


/*************************
     ÑÁ·©·i µe”a.
**************************/
void open_file()
{
  int f;

  if( (f = _open( file_name, O_RDONLY )) != CANCEL ){
    _read( f, &header, sizeof( header ) );
    _close( f );
    if( header.number > 99 ) header.number = 99;
    load_icon( file_name, &icon, 0, header.number );
   }
}


/*****************************
  ÑÁ·©µA Í¥Ëa •A·¡ÈáŸi ³e”a.
******************************/
void save_font()
{
  int i, f;

  f =_creat( file_name, FA_ARCH );
  header.number = icon.number;
  _write( f, &header, sizeof( header ) );

  for( i = 0; i < icon.number; i ++ )
    _write( f, (char *)icon.icon[i] + 4, 24*24 );

  _close( f );
}


/***************************
       •¡¶‘ i
****************************/
void f1_help()
{
  void (*temp1)(), (*temp2)();
  char *message[] = { "LBM ¦Ÿa‹¡ - [Ctrl]+[L]",
                      "·¡•· ˆe‰b  - [+],[-]",
                      "‹aŸ± ¸s‹¡  - [ENTER]",
                      "¸á¸w       - [Ctrl]+[S]",
                      "¬wÈ       - [SPACE]",
                      "{‹¡     - [ESC]",
                     };

  temp1 = _user_handle[0];
  temp2 = _user_handle[1];
  _user_handle[0] = NULL;
  _user_handle[1] = click_any_key;

  make_message( message, 5 );

  _user_handle[0] = temp1;
  _user_handle[1] = temp2;
}


/****************************
  LBMÑÁ·©·i ÑÁ¡eµA Îa¯¡Ðe”a.
*****************************/
void decode_lbm( char *file_name )
{
  int i, f;
  byte body[5], code;
  dword length;
  char *data;

  if( (f = _open(file_name, O_RDONLY)) == CANCEL ) return;
  while( !strstr( body, "BODY" ) ){
    _read( f, &code, 1 );
    if( code >= 'A' && code <= 'Z' ){
      for( i = 0; code >= 'A' && code <= 'Z'; i ++ ){
	body[ i ] = code;
        _read( f, &code, 1 );
       }
      body[ i ] = '\0';
     }
   }
  lseek( f, 3, SEEK_CUR );

  length = filelength( f ) - 0x37 + 256*3;
  data = farmalloc( length );
  _read( f, data, length );
  _close( f );

  decode_picture( data, 0 );
  farfree( data );
}


/************************
   LBM ÑÁ·©·i ¦Ÿe”a.
*************************/
void load_pic()
{
  void (*temp1)(), (*temp2)();
  window_data window;

  temp1 = _user_handle[0];
  temp2 = _user_handle[1];
  _user_handle[0] = NULL;
  _user_handle[1] = NULL;

  center_window( 8*17+15, 16+15, &window );
  make_str_double( window.x + 8, window.y + 8, "‹aŸ±¡w :", YELLOW, 1 );

  do{
    bar( window.x + 8*9+8, window.y + 8, window.x + 8*17+8, window.y + 16+8, LIGHTGRAY );
    input_string( window.x + 8*9+8, window.y + 8, pic_name, WHITE, 8 );
   } while( strlen(pic_name) <= 0 );

  close_window( &window );

  strcat( pic_name, ".GPG" );
  load_picture( pic_name, 0 );

  _user_handle[0] = temp1;
  _user_handle[1] = temp2;
}


/***************************
  ¯aÏaœa·¡ËaŸi ¸s“e”a.
****************************/
void capture()
{
  if( icon.number < 98 ){
    get_image( x, y, x + 23, y + 23, &icon.icon[icon.number] );
    icon.number ++;
   }
}


/***************************
    Ñe¸· ¬wÈ Îa¯¡
****************************/
void state_info()
{
  int i;
  window_data window;
  void (*temp1)(), (*temp2)();
  char *message[] = { "* ÑÁ·©¡w  :",
                      "Ñe¸‹aŸ±  :",
                      "Ñe¸ Í¥Ëa :",
                      "X,Y ¹ÁÎa  :",
                     };

  temp1 = _user_handle[0];
  temp2 = _user_handle[1];
  _user_handle[0] = NULL;
  _user_handle[1] = click_any_key;

  center_window( 24*8+15, 4*18+15, &window );

  for( i = 0; i < 4; i ++ )
    make_str_double( window.x + 8, window.y + 8 + i * 18, message[i], YELLOW, 1 );

  make_str( window.x+12*8+8, window.y+18*0+8, file_name, WHITE );
  make_str( window.x+12*8+8, window.y+18*1+8, pic_name,  WHITE );
  make_str( window.x+12*8+8, window.y+18*2+8, str(icon.number), WHITE );
  make_str( window.x+12*8+8, window.y+18*3+8, str(x),    WHITE );
  make_str( window.x+15*8+8, window.y+18*3+8, ",",       WHITE );
  make_str( window.x+16*8+8, window.y+18*3+8, str(y),    WHITE );
  get_key();

  close_window( &window );
  _user_handle[0] = temp1;
  _user_handle[1] = temp2;
}


static void quit_index()
{
  if( check_mouse( 88, 101, 138, 119 ) )  put_key( LEFT );
  if( check_mouse( 183, 101, 233, 119 ) ) put_key( RIGHT );
}

static void quit_click()
{
  if( check_mouse( 88, 101, 138, 119 ) || check_mouse( 183, 101, 233, 119 ) ){
    put_key( ENTER );
    delay_program( 100 );
   }
}

static void click_space()
{
  put_key( SPACE );
}

static void index_box()
{
  box_xor( x, y, x+23, y+23 );
  x = _mouse.x; y = _mouse.y;
  box_xor( x, y, x+23, y+23 );
}

static void cap_box()
{
  box_xor( x, y, x+23, y+23 );
  capture();
  box_xor( x, y, x+23, y+23 );
}


/***************************
   Ïa¡‹aœ‘·i »¥Ð—Ðe”a.
****************************/
void icon_cap()
{
  int ch;
  void (*temp1)(), (*temp2)();
  int quit_flag = FALSE;

  do{
    ch = get_key();
    box_xor( x, y, x+23, y+23 );

    switch( ch ){
      case F1         : f1_help();        break;
      case ENTER      : capture();        break;

      case UP_LEFT    : x --; y --; break;
      case UP         :       y --; break;
      case UP_RIGHT   : x ++; y --; break;
      case LEFT       : x --;       break;
      case RIGHT      : x ++;       break;
      case DOWN_LEFT  : x --; y ++; break;
      case DOWN       :       y ++; break;
      case DOWN_RIGHT : x ++; y ++; break;

      case CTRL_S     : save_font();          break;
      case CTRL_L     : load_pic();           break;
      case SPACE      : state_info();         break;
      case ESC        : temp1 = _user_handle[0];
                        temp2 = _user_handle[1];
                        _user_handle[0] = quit_index;
                        _user_handle[1] = quit_click;
                        mouse_cursor_on();
                        quit_flag = reply_quit();
                        mouse_cursor_off();
                        _user_handle[0] = temp1;
                        _user_handle[1] = temp2;
    }
    if( x > 320-24 ) x = 320-24;
    if( y > 200-24 ) y = 200-24;
    if( x < 0 )  x = 0;
    if( y < 0 )  y = 0;

    locate_mouse_cursor( x, y );
    box_xor( x, y, x+23, y+23 );
   } while( !quit_flag );
}


main( int argc, char *argv[] )
{
  init_screen();
  init_mouse();
  locate_mouse_cursor( 0, 0 );
  set_mouse_window( 0, 0, 320-24, 200-24 );

  if( argc < 2 )
    input_filename();
   else{
    strcpy( file_name, argv[1] );
    strcat( file_name, ".ICO" );
   }

  if( argc > 2 ){
    strcpy( pic_name, argv[2] );
    strcat( pic_name, ".GPG" );
    load_picture( pic_name, 0 );
   }
  else
    load_pic();

  open_file();
  box_xor( x, y, x+23, y+23 );
  _user_handle[0] = index_box;
  _user_handle[1] = cap_box;
  _user_handle[2] = click_space;

  icon_cap();

  close_mouse();
  close_game13h();
}
