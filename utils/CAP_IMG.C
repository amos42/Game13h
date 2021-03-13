/***********************************
     ¡¡—a 13h ¸å¶w IMG Ä“Áa.

                 ¹A¸b¸a : º‰w£¥

    File Name : CAP_IMG.C

 * ‹a¶A ”á Ï©¶aÐe ÑÁ·©;
 GAME13H.H    -- œa·¡§aœáŸ¡· ÑA”á
 GAME13H.LIB
***********************************/
#include <game13h.h>  /* Ver 4.2 */

#define CTRL_S  0x13
#define CTRL_L  0x0C


char pic_name[12 + 1];
char file_name[12 + 1];   /* Íe»³Ði ÑÁ·©¡w        */
char *font;               /* Í¥ËaŸi ¸á¸wÐi ¤µi   */
int size_x, size_y;
int img_size;
int x = 0, y = 0;
int step = 1;


/***********************
  ÑÁ¡e·i Á¡‹¡ÑÁ Ðe”a.
************************/
void init_screen()
{
  char *title[] = { "  13h GPG Capture",
                    "         Ver 1.1",
                    "",
                    "     e—e·¡ : º‰w£¥",
                   };

  init_game13h();
  clear_screen( BLUE );
  make_message( title, 4 );
}


/*****************************
  ÑÁ·©µA Í¥Ëa •A·¡ÈáŸi ³e”a.
******************************/
void save_font()
{
  int i, f;
  struct image_header header = { "Game13h Image__", 1, 1, NULL };

  header.offset[0] = sizeof( header ) + 0;

  f =_creat( file_name, FA_ARCH );
    _write( f, &header, sizeof( header ) );
    _write( f, font, img_size );
  _close( f );
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


/****************************
  ˆb ¥e®Ÿi Á¡‹¡ÑÁ ¯¡Ç¥”a.
*****************************/
void init_value()
{
  char number[3 + 1];

  draw_window( 112, 50, 207, 97 );
  make_str_double( 120, 58, "X Ça‹¡“e ?", YELLOW, 1 );

  do{
    bar( 112+36, 50+25, 112+36 + 3*8, 50+25 + 16, LIGHTGRAY );
    input_string( 112+36, 50+25, number, WHITE, 3 );
    size_x = atoi( number );
   } while( strlen(number) <= 0 || size_x < 3 || size_x > V_RES/2 );

  draw_window( 112, 102, 207, 149 );
  make_str_double( 120, 110, "Y Ça‹¡“e ?", YELLOW, 1 );

  do{
    bar( 112+36, 102+25, 112+36 + 3*8, 102+25 + 16, LIGHTGRAY );
    input_string( 112+36, 102+25, number, WHITE, 3 );
    size_y = atoi( number );
   } while( strlen(number) <= 0 || size_y < 3 || size_y > V_RES/2 );

  img_size = size_x * size_y + 4;
}


/***************************
  ¯aÏaœa·¡ËaŸi ¸s“e”a.
****************************/
void capture()
{
  register int i;
  char *image;

  get_image( x, y, x + size_x-1, y + size_y-1, &image );

  for( i = 0; i < img_size; i ++ )
    ((char *)font)[i] = ((char *)image)[i];
  free( image );
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
       •¡¶‘ i
****************************/
void f1_help()
{
  char *message[] = { "GPG ¦Ÿa‹¡ - [Ctrl]+[L]",
                      "·¡•· ˆe‰b  - [+],[-]",
                      "‹aŸ± ¸s‹¡  - [ENTER]",
                      "¸á¸w       - [Ctrl]+[S]",
                      "{‹¡     - [ESC]",
                     };

  make_message( message, 5 );
}


/*************************
   Ïa¡‹aœ‘·i »¥Ð—Ðe”a.
**************************/
void dat_cap()
{
  int ch;

  do{
    ch = get_key();
    box_xor( x, y, x+size_x-1, y+size_y-1 );
    switch( ch ){
      case F1         : f1_help();            break;
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
    }
    if( x > 320-size_x ) x = 320-size_x;
    if( y > 200-size_y ) y = 200-size_y;
    if( x < 0 )  x = 0;
    if( y < 0 )  y = 0;

    box_xor( x, y, x+size_x-1, y+size_y-1 );
   } while( ch != ESC );
}


main( int argc, char *argv[] )
{
  if( argc < 2 ){
    puts("Usege : CAP_IMG filename [GPG_name]");
    exit(1);
   }
  strcpy( file_name, argv[1] );
  strcat( file_name, ".IMG" );

  if( argc > 2 ){
    strcpy( pic_name, argv[2] );
    strcat( pic_name, ".GPG" );
    load_picture( pic_name, 0 );
   }

  init_screen();

  init_value();
  load_gpg();
  font = farmalloc( img_size );
  box_xor( x, y, x+size_x-1, y+size_y-1 );

  do
    dat_cap();
  while( !reply_quit() );

  farfree( font );
  close_game13h();
}
