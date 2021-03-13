/***********************************
    GPG ÑÁ·©·i ·¡¶wÐe ICO  e—i‹¡

                 ¹A¸b¸a : º‰w£¥

    File Name : CAP_ICO.C

 * ‹a¶A ”á Ï©¶aÐe ÑÁ·©;
 GAME13H.H    -- œa·¡§aœáŸ¡· ÑA”á
 GAME13H.LIB
***********************************/
#include <game13h.h>  /*  Ver 4.2  */

#define CTRL_S  0x13
#define CTRL_L  0x0C


char file_name[12 + 1]; /* Íe»³Ði ÑÁ·©¡w      */
char pic_name[12 + 1];  /* ‹aŸ±ÑÁ·© ·¡Ÿq      */
image_data temp[42];
icon_data icon = { 0, 16, 16, temp };
int x = 0, y = 0;
int step = 1;

struct icon_header header = { "Game13h Icon___", 1, 0, 16, 16 };


/***********************
  ÑÁ¡e·i Á¡‹¡ÑÁ Ðe”a.
************************/
void init_screen()
{
  char *title[] = { "  13h GPG Capture",
                    "        Ver 1.21",
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
  int i, f;

  if( (f = _open( file_name, O_RDONLY )) != CANCEL ){
    _read( f, &header, sizeof( header ) );
    if( strcmp( header.head_id, "Game13h Icon___" ) ){
      _close( f );
      return;
     }
    if( header.number >= 64 ){
      _close( f );
      return;
     }
    icon.number = header.number;
    for( i = 0; i < icon.number; i ++ ){
      icon.icon[i] = farmalloc( 4 + 16*16 );
      icon.icon[i][0] = icon.icon[i][2] = 16;
      icon.icon[i][1] = icon.icon[i][3] = 0;
      _read( f, &icon.icon[i][4], 256 );
    }
    _close( f );
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
    _write( f, &icon.icon[i][4], 256 );

  _close( f );
}


/***************************
       •¡¶‘ i
****************************/
void f1_help()
{
  char *message[] = { "GPG ¦Ÿa‹¡ - [Ctrl]+[L]",
                      "·¡•· ˆe‰b  - [+],[-]",
                      "‹aŸ± ¸s‹¡  - [ENTER]",
                      "¸á¸w       - [Ctrl]+[S]",
                      "¬wÈ       - [SPACE]",
                      "{‹¡     - [ESC]",
                     };

  make_message( message, 5 );
}


/************************
   GPG ÑÁ·©·i ¦Ÿe”a.
*************************/
void load_gpg()
{
  window_data window;

  center_window( 8*17+15, 16+15, &window );
  make_str_double( window.x + 8, window.y + 8, "‹aŸ±¡w :", YELLOW, 1 );

  do{
    bar( window.x + 8*9+8, window.y + 8, window.x + 8*17+8, window.y + 16+8, LIGHTGRAY );
    input_string( window.x + 8*9+8, window.y + 8, pic_name, WHITE, 8 );
   } while( strlen(pic_name) <= 0 );

  close_window( &window );

  strcat( pic_name, ".GPG" );
  load_picture( pic_name, 0 );
}


/***************************
  ¯aÏaœa·¡ËaŸi ¸s“e”a.
****************************/
void capture()
{
  if( icon.number < 41 )
    get_image( x, y, x + 15, y + 15, &icon.icon[icon.number++] );
}


/***************************
    Ñe¸· ¬wÈ Îa¯¡
****************************/
void state_info()
{
  int i;
  window_data window;
  char *message[] = { "* ÑÁ·©¡w  :",
                      "Ñe¸‹aŸ±  :",
                      "Ñe¸ Í¥Ëa :",
                      "·¡•· ˆe‰b :",
                      "X,Y ¹ÁÎa  :",
                     };

  center_window( 24*8+15, 5*18+15, &window );

  for( i = 0; i < 5; i ++ )
    make_str_double( window.x + 8, window.y + 8 + i * 18, message[i], YELLOW, 1 );

  make_str( window.x+12*8+8, window.y+18*0+8, file_name, WHITE );
  make_str( window.x+12*8+8, window.y+18*1+8, pic_name,  WHITE );
  make_str( window.x+12*8+8, window.y+18*2+8, str(icon.number), WHITE );
  make_str( window.x+12*8+8, window.y+18*3+8, str(step), WHITE );
  make_str( window.x+12*8+8, window.y+18*4+8, str(x),    WHITE );
  make_str( window.x+15*8+8, window.y+18*4+8, ",",       WHITE );
  make_str( window.x+16*8+8, window.y+18*4+8, str(y),    WHITE );
  get_key();

  close_window( &window );
}


/*********************
  ·¡•· ˆe‰b·i µ©Ÿ¥”a.
**********************/
void up_step()
{
  char s_step[3];
  window_data window;

  if( step < 32 ) step ++;

  center_window( 32, 25, &window );

  itoa( step, s_step, 10 );
  make_str_double( window.x + 9, window.y + 6, s_step, WHITE, 1 );
  get_key();
  close_window( &window );
}


/*********************
  ·¡•· ˆe‰b·i Ÿ¥”a.
**********************/
void down_step()
{
  char s_step[3];
  window_data window;

  if( step > 1 ) step --;

  center_window( 32, 25, &window );

  itoa( step, s_step, 10 );
  make_str_double( window.x + 9, window.y + 6, s_step, WHITE, 1 );
  get_key();
  close_window( &window );
}


/***************************
   Ïa¡‹aœ‘·i »¥Ð—Ðe”a.
****************************/
void dat_cap()
{
  int ch;

  do{
    ch = get_key();
    box_xor( x, y, x+15, y+15 );
    switch( ch ){
      case F1         : f1_help();        break;
      case ENTER      : capture();            break;
      case '+'        : up_step();            break;
      case '-'        : down_step();          break;

      case UP_LEFT    : x -= step; y -= step; break;
      case UP         :            y -= step; break;
      case UP_RIGHT   : x += step; y -= step; break;
      case LEFT       : x -= step;            break;
      case RIGHT      : x += step;            break;
      case DOWN_LEFT  : x -= step; y += step; break;
      case DOWN       :            y += step; break;
      case DOWN_RIGHT : x += step; y += step; break;

      case CTRL_S     : save_font();          break;
      case CTRL_L     : load_gpg();           break;
      case SPACE      : state_info();         break;
    }
    if( x > 304 ) x = 304;
    if( y > 184 ) y = 184;
    if( x < 0 )  x = 0;
    if( y < 0 )  y = 0;

    box_xor( x, y, x+15, y+15 );
   } while( ch != ESC );
}


main( int argc, char *argv[] )
{
  init_screen();

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
    load_gpg();

  open_file();
  box_xor( x, y, x+15, y+15 );

  do
    dat_cap();
   while( !reply_quit() );

  close_game13h();
}

