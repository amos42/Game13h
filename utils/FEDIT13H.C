/***********************************
     ¡¡—a 13h ¸å¶w Í¥Ëa µA—¡Èá.

                 ¹A¸b¸a : º‰w£¥
                          ¯¥•·»¥

    File Name : FEDIT13H.C

 * ‹a¶A ”á Ï©¶aÐe ÑÁ·©;
 GAME13H.H    -- œa·¡§aœáŸ¡· ÑA”á
 GAME13H.LIB
 FEDIT13H.GPG -- Í¥Ëa µA—¡Èá· ¡A·¥
                 ÑÁ¡e •A·¡Èá.
***********************************/
#include <game13h.h>  /*  Ver 4.2  */


#define CTRL_S 0x13
#define CTRL_L 0x0C
#define CTRL_N 0x0E
#define INS    0x5200
#define DEL    0x5300


char path[80];
int  font_number;                /* Í¥Ëa· ˆ•®        */
char file_name[12 + 1];          /* Íe»³Ði ÑÁ·©¡w      */
char font[42][256 + 4];          /* Í¥ËaŸi ¸á¸wÐi ¤µi */
char buffer[3][256 + 4] = {0, }; /* ¤áÌá¡ ³a·© ¤µi   */
byte color = BLACK;
int dot_x, dot_y;
int select;
int click_effect_flag = FALSE;
int index = 0;

struct icon_header header = { "Game13h Icon___", 1, 0, 16, 16 };


/***********************
  ÑÁ¡e·i Á¡‹¡ÑÁ Ðe”a.
************************/
void init_screen()
{
  char pic_name[80];
  char *title[] = { " 13h Font Editor",
                    "        Ver 3.0",
                    "",
                    "  e—e·¡ : º‰w£¥",
                    "          ¯¥•·»¥",
                   };

  init_game13h();

  strcpy( pic_name, path );
  strcat( pic_name, "FEDIT13H.GPG" );
  load_picture( pic_name, 0 );
  make_message( title, 5 );
}


/***********************
  ¤áÌáŸi Á¡‹¡ÑÁ ¯¡Ç¥”a.
************************/
void init_buffer()
{
  register int i;

  for( i = 0; i < 3; i ++ ){
    buffer[i][0] = buffer[i][2] = 0x10;
    buffer[i][1] = buffer[i][3] = 0x00;
   }
}


/************************
  Í¥ËaŸi Á¡‹¡ÑÁ Ðe”a.
*************************/
void init_icon()
{
  register int i, j;

  for( i = 0; i < 42; i ++ ){
    font[i][0] = font[i][2] = 0x10;
    font[i][1] = font[i][3] = 0x00;
    for( j = 0; j < 256; j ++ )
      font[i][j+4] = _attr_null_color;
   }
}


/***********************
  ÑÁ·©¡w·i ·³b ¤h“e”a.
************************/
void input_filename()
{
  int x, y;
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
  window_data window;
  char number[3];
  struct icon_header temp;

  if( (f = _open( file_name, O_RDONLY )) != CANCEL ){
    _read( f, &temp, sizeof( temp ) );
    if( strcmp( temp.head_id, "Game13h Icon___" ) ){
      _close( f );
      return;
     }
    font_number = temp.number;
    if( font_number > 42 ) font_number = 42;
    for( i = 0; i < font_number; i ++ ){
      _read( f, &font[i][4], 256 );
     }
    _close( f );
   }
  else{
    center_window( 8*18+15, 16+15, &window );
    make_str_double( window.x + 8, window.y + 8, "Í¥Ëa ˆ•®(1~42):", YELLOW, 1 );
    input_string( window.x + 8*16+8, window.y + 8, number, WHITE, 2 );
    close_window( &window );
    font_number = atoi( number );
    if( font_number > 42 ) font_number = 42;
    if( font_number < 1  ) font_number = 1;
   }

  bar( 16, 23, 147, 176, LIGHTGRAY );
}


/*****************************
  ÑÁ·©µA Í¥Ëa •A·¡ÈáŸi ³e”a.
******************************/
void write_file()
{
  int i, f;

  f = _creat( file_name, FA_ARCH );

  header.number = font_number;
  _write( f, &header, sizeof( header ) );

  for( i = 0; i < font_number; i ++ )
    _write( f, &font[i][4], 256 );

  _close( f );
}


/***************************
   ¬åÈ‚–E Í¥ËaŸi Îa¯¡Ðe”a.
****************************/
void index_font( int index, char color )
{
  word x, y;

  x = (int)(index % 6) * 20 + 23;
  y = (int)(index / 6) * 20 + 31;

  box( x, y, x + 17, y + 17, color );
}


/****************************
  ·³b¤h·e ¹ÁÎaŸi Îa¯¡Ðe”a.
    ( Í¥Ëa µA—¡Ëa¯¡ )
****************************/
void index_xy( int x, int y, char color )
{
  box( x * 7 + 25, y * 7 + 59, x * 7 + 32, y * 7 + 66, color );
}


/***************************
  ·³b¤h·e ÄéœáŸi Îa¯¡Ðe”a.
     ( Í¥Ëa µA—¡Ëa¯¡ )
****************************/
void index_color( int index, char color )
{
  word x, y;

  x = (int)(index / 16) * 8 + 175;
  y = (int)(index % 16) * 8 + 56;

  box( x, y, x + 8, y + 8, color );
}


/***************************
      ¸ñ·i ¿¢“e”a.
     (Í¥Ëa µA—¡Ëa¯¡)
****************************/
void dot_put(int x, int y, int index, char color )
{
  int i;

  i = x + y *16 + 4;
  font[index][i] = color;

  bar( x * 7 + 26, y * 7 + 60, x * 7 + 31, y * 7 + 65, color );
  put_pixel( x + 74, y + 34, color );
}


void click_ani_key()
{
  put_key( ENTER );
}


/***************************
  Í¥Ëa µA—¡Èá· •¡¶‘ i
     (Í¥Ëa µA—¡Ëa¯¡)
****************************/
void editor_help()
{
  void (*temp)();
  char *message[] = { "¸ñ ¿¢‹¡   - [SPACE]",
                      "‰­¢ ¿¢‹¡ - [C]",
                      "¯aÍ¡·¡—a  - [S]",
                      "¬‚Œi ¬åÈ‚ - [ENTER]",
                      "{‹¡    - [ESC]",
                    };

  temp = _user_handle[1];
  _user_handle[1] = click_ani_key;
  mouse_cursor_off();
  make_message( message, 5 );
  mouse_cursor_on();
  _user_handle[1] = temp;
}


/**************************
  Í¥Ëa µA—¡Èá· •¡¶‘ i
     (Í¥Ëa ¬åÈ‚¯¡)
***************************/
void select_help()
{
  void (*temp)();
  char *message[] = { "Í¥Ëa ¬åÈ‚  - [ENTER]",
                      "¬ ÑÁ·©    - [Ctrl]+[N]",
                      "ÑÁ·© ¡—a  - [Ctrl]+[L]",
                      "ÑÁ·© ¸á¸w  - [Ctrl]+[S]",
                      "Í¥Ëa ¬s·³  - [Ins]",
                      "Í¥Ëa ¬b¹A  - [Del]",
                      "¤áÌá¡..   - [>]",
                      "¤áÌáµA¬á.. - [<]",
                      "¹·ža       - [ESC]",
                    };

  temp = _user_handle[1];
  _user_handle[1] = click_ani_key;
  mouse_cursor_off();
  make_message( message, 9 );
  mouse_cursor_on();
  _user_handle[1] = temp;
}


/***************************
    ¬‚Œi·i ¬åÈ‚Ðe”a.
****************************/
void select_color()
{
  int ch;
  byte temp_color = color;

  mouse_cursor_on();

  do{
    ch = get_key();
    mouse_cursor_off();
    index_color( color, WHITE );
    switch( ch ){
      case ESC        : color = temp_color;
                        index_color( color, LIGHTBLUE );
                        return;
      case UP_LEFT    : color -= 17; break;
      case UP         : color --;    break;
      case UP_RIGHT   : color += 15; break;
      case LEFT       : color -= 16; break;
      case RIGHT      : color += 16; break;
      case DOWN_LEFT  : color -= 15; break;
      case DOWN       : color ++;    break;
      case DOWN_RIGHT : color += 17; break;
     }
    index_color( color, LIGHTBLUE );
    mouse_cursor_on();
   } while( ch != ENTER );

  mouse_cursor_off();
}


/***************************
  Ñe¸ ¹ÁÎaŸi Îa¯¡Ðe”a.
    (Í¥Ëa µA—¡Ëa¯¡)
****************************/
void display_sqr( int x, int y )
{
  bar( 58, 182, 105, 196, LIGHTGRAY );

  make_str( 58, 182, str(x), WHITE );;
  make_str( 78, 182, ",", WHITE );
  make_str( 88, 182, str(y), WHITE );;
}


/***************************************
   a¶¯a ¬a¶w¸a ·¡¥EËa Ð…—i·i ¬é¸÷Ðe”a.
****************************************/
void button_click()
{
  if( check_mouse( 25, 59, 136, 170 ) ){
    mouse_cursor_off();
    index_xy( dot_x, dot_y, WHITE );
    dot_x = ( _mouse.x - 25 ) / 7;
    dot_y = ( _mouse.y - 59 ) / 7;
    index_xy( dot_x, dot_y, LIGHTBLUE );
    dot_put( dot_x, dot_y, select, color );
    display_sqr( dot_x, dot_y );
    mouse_cursor_on();
   }
  if( check_mouse( 175, 56, 303, 184 ) ){
    mouse_cursor_off();
    index_color( color, WHITE );
    color = (( _mouse.x - 175 ) / 8)*16 + ( _mouse.y - 56 ) / 8;
    index_color( color, LIGHTBLUE );
    mouse_cursor_on();
   }
  if( check_mouse( 73, 33, 90, 50 ) )
    put_key( ESC );
}


void button_select_icon()
{
  int x, y, temp_index;

  if( _mouse.x < 23 || _mouse.y < 23 ) return;

  x = (_mouse.x - 23) / 20;
  y = (_mouse.y - 23) / 20;

  temp_index = y * 6 + x;
  if( temp_index < font_number ){
    mouse_cursor_off();
    index_font( index, LIGHTGRAY );
    index = temp_index;
    index_font( index, LIGHTBLUE );
    put_key( ENTER );
    mouse_cursor_on();
   }
}


/***************************
   Í¥Ëa µA—¡ÈáŸi »¥Ð—Ðe”a.
****************************/
void editor( int index )
{
  int i, x = 0, y = 0;
  char continue_flag = FALSE;
  char spoide_flag   = FALSE;
  int ch = NULL;

  mouse_cursor_off();

  /* µA—¡Ëa ÑÁ¡e·i Á¡‹¡ÑÁ */
  bar( 16, 23, 147, 176, LIGHTGRAY );
  draw_window( 67, 27, 96, 56 );

  box( 73, 33, 90, 50, BLACK );
  copy_put( 74, 34, font[index] );
  bar( 26, 60, 138, 172, BLACK );
  for( i = 0; i < 16; i ++ )
    line_horiz( 25, 59 + i * 7, 112, WHITE );
  for( i = 0; i < 16; i ++ )
    line_vert( 25 + i * 7, 59, 112, WHITE );

  line_horiz( 25, 171, 112, WHITE );
  line_vert( 137, 59,  112, WHITE );

  for( i = 0; i < 256; i ++, x ++ ){
    if( x >= 16 ){
      y ++;
      x = 0;
     }
    dot_put( x, y, index, font[index][i+4] );
   }
  dot_x = dot_y = 0;
  display_sqr( dot_x, dot_y );

  /* Ñe¸· ¹ÁÎaµÁ ¬‚¬w·i Îa¯¡Ðe”a. */
  index_xy( dot_x, dot_y, LIGHTBLUE );
  index_color( color, LIGHTBLUE );

  select = index;
  _user_handle[1] = button_click;

  mouse_cursor_on();

  do{
    ch = get_key();
    mouse_cursor_off();
    index_xy( dot_x, dot_y, WHITE );
    switch( ch ){
      case F1         : editor_help(); break;
      case ENTER      : select_color( &color ); break;
      case UP_LEFT    : dot_x --; dot_y --; break;
      case UP         :           dot_y --; break;
      case UP_RIGHT   : dot_x ++; dot_y --; break;
      case LEFT       : dot_x --;           break;
      case RIGHT      : dot_x ++;           break;
      case DOWN_LEFT  : dot_x --; dot_y ++; break;
      case DOWN       : dot_y ++;           break;
      case DOWN_RIGHT : dot_x ++; dot_y ++; break;
      case 'c'        :
      case 'C'        : continue_flag = !continue_flag;
                        spoide_flag = FALSE;
                        break;
      case 's'        :
      case 'S'        : spoide_flag = !spoide_flag;
                        continue_flag = FALSE;
                        break;
      case SPACE      : dot_put( dot_x, dot_y, index, color );
                        spoide_flag = continue_flag = FALSE;
                        break;
     }
    if( dot_x > 15 ) dot_x = 0;
    if( dot_y > 15 ) dot_y = 0;
    if( dot_x < 0 )  dot_x = 15;
    if( dot_y < 0 )  dot_y = 15;

    if( continue_flag )
      dot_put( dot_x, dot_y, index, color );

    display_sqr( dot_x, dot_y );

    if( spoide_flag ){
      index_color( color, WHITE );
      i = dot_x + dot_y *16 + 4;
      color = font[index][i];
      index_color( color, LIGHTBLUE );
     }

    index_xy( dot_x, dot_y, LIGHTBLUE );
    mouse_cursor_on();
   } while( ch != ESC );

  bar( 58, 183, 105, 194, LIGHTGRAY );
  _user_handle[1] = button_select_icon;
}


/*********************************
  Í¥Ëa ñ¤á¡ ÑÁ¡eµA Í¥ËaŸi Îa¯¡
**********************************/
void index_put_font( int index )
{
  word x, y;

  x = (int)(index % 6) * 20 + 24;
  y = (int)(index / 6) * 20 + 32;

  copy_put( x, y, font[index] );
}


/*****************************
  Í¥Ëa ¬åÈ‚ÑÁ¡e·i Á¡‹¡ÑÁÐe”a.
******************************/
void init_select()
{
  register int i;

  for( i = 0; i < font_number; i ++ )
    index_put_font( i );

  make_str( 250, 21, str(0), WHITE );
  make_str( 270, 21, "/",     YELLOW );
  make_str( 280, 21, str(font_number-1), WHITE );
}


/****************
  ¤áÌáŸi ¬åÈ‚
*****************/
int select_buffer()
{
  int x, y;
  char number[2], buffer_number;
  window_data window;

  center_window( 14*8+15, 16+15, &window );
  make_str_double( window.x + 8, window.y + 8, "¤áÌá“e?(1~3)", YELLOW, 1 );

  do{
    bar( window.x + 14*7+8, window.y + 8, window.x + 14*8+8, window.y + 8+15, LIGHTGRAY );
    input_string( window.x + 14*7+8, window.y + 8, number, WHITE, 1 );
    buffer_number = atoi( number ) - 1;
   } while( buffer_number < 0 || buffer_number > 2 );

  close_window( &window );
  return( buffer_number );
}


/*****************
  ¤áÌá¡ ¥¢¬a
******************/
void to_buffer( int index )
{
  register int i;
  char buffer_number;

  buffer_number = select_buffer();
  for( i = 0; i < 260; i ++ )
    buffer[buffer_number][i] = font[index][i];

  copy_put( buffer_number * 20 + 181, 19, buffer[buffer_number] );
}


/******************
  ¤áÌáµA¬á ¥¢¬a
*******************/
void from_buffer( int index )
{
  register int i;
  char buffer_number;

  buffer_number = select_buffer();
  for( i = 0; i < 260; i ++ )
    font[index][i] = buffer[buffer_number][i];

  index_put_font( index );
}


/********************
  ´a·¡Å¥·i ÂˆaÐe”a.
*********************/
void insert_icon( int index )
{
  register int i, j;

  if( font_number > 41 ) return;

  for( i = font_number; i > index; i -- ){
    for( j = 4; j < 260; j ++ )
      font[i][j] = font[i - 1][j];
    index_put_font( i );
   }

  for( i = 4; i < 260; i ++ )
    font[index][i] = _attr_null_color;
  index_put_font( index );

  font_number ++;
}


/*********************
  ´a·¡Å¥·i ¬b¹AÐe”a.
**********************/
void delete_icon( int *index )
{
  register int i, j;

  if( font_number < 2 ) return;
  font_number --;

  for( i = *index; i < font_number; i ++ ){
    for( j = 4; j < 260; j ++ )
      font[i][j] = font[i + 1][j];
    index_put_font( i );
   }

  for( i = 4; i < 260; i ++ )
    font[font_number][i] = LIGHTGRAY;
  index_put_font( font_number );

  if( *index > font_number - 1) (*index) --;
}


/****************************
  ¬¡¶… Í¥ËaŸi ·³b¤h“e”a.
*****************************/
void new_file(int *index)
{
  input_filename();
  init_icon();
  open_file();
  *index = 0;
  init_select();
}


void quit_index()
{
  if( _mouse.y > 101 && _mouse.y < 119 ){
    if( _mouse.x > 88  && _mouse.x < 138 ){
      put_key( LEFT );
      click_effect_flag = TRUE;
     } else
    if( _mouse.x > 183 && _mouse.x < 233 ){
      put_key( RIGHT );
      click_effect_flag = TRUE;
     } else
      click_effect_flag = FALSE;
   } else
    click_effect_flag = FALSE;
}


void mouse_click()
{
  if( click_effect_flag ){
    put_key( ENTER );
    delay_program( 200 );
   }
}


/**************************
  Íe»³Ði Í¥ËaŸi ¬åÈ‚Ðe”a.
***************************/
void select_icon_data()
{
  int old_index;
  char quit_flag = FALSE;
  char *number;
  int ch;

  mouse_cursor_off();

  get_image( 250, 21, 298, 32, &number );
  init_select();
  index_font( 0, LIGHTBLUE );

  mouse_cursor_on();
  _user_handle[1] = button_select_icon;

  do{
    ch = get_key();
    mouse_cursor_off();
    old_index = index;
    index_font( index, LIGHTGRAY );

    switch( ch ){
      case F1     : select_help();            break;
      case CTRL_S : write_file();             break;
      case CTRL_L : open_file();
                    init_select();
                    index_font( 0, LIGHTBLUE );
                    index = 0;
                    break;
      case CTRL_N : new_file(&index);         break;

      case '>'    : to_buffer( index );       break;
      case '<'    : from_buffer( index );     break;
      case INS    : insert_icon( index );     break;
      case DEL    : delete_icon(&index);      break;

      case UP     : index -= 6;               break;
      case LEFT   : index --;                 break;
      case RIGHT  : index ++;                 break;
      case DOWN   : index += 6;               break;

      case ENTER  : editor( index );
                    mouse_cursor_off();
                    bar( 16, 23, 147, 176, LIGHTGRAY );
                    init_select();
                    break;

      case ESC    : _user_handle[0] = quit_index;
                    _user_handle[1] = mouse_click;
                    quit_flag = reply_quit();
                    _user_handle[0] = NULL;
                    _user_handle[1] = button_select_icon;
                    break;

     }

    if( index >= font_number || index < 0 )
      index = old_index;

    copy_put( 250, 21, number );
    make_str( 250, 21, str(index), WHITE );;
    make_str( 270, 21, "/",        YELLOW );
    make_str( 280, 21, str(font_number-1), WHITE );;

    index_font( index, LIGHTBLUE );
    mouse_cursor_on();
   } while( !quit_flag );

  _user_handle[1] = NULL;
  free( number );
}


void init_mouse_cursor()
{
  byte mouse_cursor[256 + 4] = { 0x10, 0x00, 0x10, 0x00,
    0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xC8, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00,
    0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xC8, 0x00,
    0xFF, 0x00, 0xD3, 0xC5, 0xC8, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0x00, 0xC8, 0x00, 0xD3, 0xC5, 0xC8, 0xC8, 0xC8, 0x00, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xC8, 0xC5, 0xCF, 0xC8,
    0xC8, 0xC8, 0xC8, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xD3,
    0x00, 0xC8, 0xC5, 0xC8, 0xC8, 0xC8, 0xCF, 0xD8, 0x00, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0x00, 0xD5, 0x00, 0xC8, 0xC8, 0xC8, 0xCF, 0xD8, 0xE3,
    0xE2, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xD3, 0xD0, 0xCF,
    0xCF, 0xD8, 0xE3, 0x40, 0xE3, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0x00, 0x00, 0x00, 0xD8, 0xE5, 0xE3, 0xE3, 0x00, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xE5, 0x00,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF,
   };

  set_mouse_cursor( mouse_cursor );
}


main( int argc, char *argv[] )
{
  get_exec_path( path );

  init_screen();
  init_buffer();
  init_mouse();
  init_icon();
  get_key();

  if( argc < 2 )
    input_filename();
   else{
    strcpy( file_name, argv[1] );
    if( strstr( file_name, "." ) == NULL )
      strcat( file_name, ".ICO" );
   }

  open_file();
  init_mouse_cursor();
  mouse_cursor_on();
  select_icon_data();

  close_mouse();
  close_game13h();
}
