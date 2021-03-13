/***********************************
     ¡¡—a 13h ¸å¶w Í¥Ëa µA—¡Èá.

                 ¹A¸b¸a : º‰w£¥

    File Name : F_EDIT.C

 * Ï©¶aÐe ÑÁ·©;
 GAME13H.H    -- œa·¡§aœáŸ¡· ÑA”á
 GAME13H.LIB  -- œa·¡§aœáŸ¡ ¥¥ÁA
 F_EDIT.C     -- µA—¡Ëa žË¥
 F_SELECT.C   -- Í¥Ëa ­IBËa žË¥
 F_MAIN.C     -- ¡A·¥ žË¥
 FEDIT.GPG    -- ÑÁ¡e •A·¡Èá
 H_GT.FNT     -- Ðe‹i Í¥Ëa
 E_GT.FNT     -- µw¢… Í¥Ëa
***********************************/
#include <game13h.h>  /*  Ver 4.2  */


#define SIZE_X  24
#define SIZE_Y  24

#define CTRL_S 0x13
#define CTRL_L 0x0C
#define CTRL_N 0x0E
#define INS    0x5200
#define DEL    0x5300


int index = 0;
int s_screen = 0;

extern char pic_name[80];
extern icon_data icon;             /* Í¥ËaŸi ¸á¸wÐi ¤µi */
extern char buffer[3][24*24 + 4];  /* ¤áÌá¡ ³a·© ¤µi   */
void click_any_key();
static button_data f1  = { 161, 12, 198, 29, FALSE },
                   esc = { 206, 12, 243, 29, FALSE };


/***************************
   ¬åÈ‚–E Í¥ËaŸi Îa¯¡Ðe”a.
****************************/
void index_font( char color )
{
  word x, y;

  x = (int)(index % 10) * 26 + 21;
  y = (int)( index / 10 - s_screen ) * 26 + 50;

  box( x, y, x + 25, y + 25, color );
}


/**************************
  Í¥Ëa µA—¡Èá· •¡¶‘ i
     (Í¥Ëa ¬åÈ‚¯¡)
***************************/
void select_help()
{
  void (*temp1)(), (*temp2)();
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

  temp1 = _user_handle[0];
  temp2 = _user_handle[1];
  _user_handle[0] = NULL;
  _user_handle[1] = click_any_key;

  mouse_cursor_off();
  push_button( &f1 );
  make_message( message, 9 );
  release_button( &f1 );
  mouse_cursor_on();

  _user_handle[0] = temp1;
  _user_handle[1] = temp2;
}


/*********************************
  Í¥Ëa ñ¤á¡ ÑÁ¡eµA Í¥ËaŸi Îa¯¡
**********************************/
void index_put_font( int index )
{
  word x, y;

  if( index >= (s_screen+5)*10 ) return;

  x = (int)(index % 10) * 26 + 22;
  y = (int)( index / 10 - s_screen ) * 26 + 51;

  copy_put( x, y, icon.icon[index] );
}


/******************************
  ¤‰w¬‚·a¡ ´a·¡Å¥·i ”ü“e”a.
*******************************/
void index_put_null( int index )
{
  word x, y;

  if( index >= (s_screen+5)*10 ) return;

  x = (int)(index % 10) * 26 + 22;
  y = (int)( index / 10 - s_screen ) * 26 + 51;

  bar( x, y, x+23, y+23, LIGHTGRAY );
}


/************************
  ¯aÇa© ¤aŸi Îa¯¡Ðe”a.
*************************/
void display_bar()
{
  int length, position;

  if( icon.number <= 50 ){
    length = 124 - 1;
    position = 53;
   }else{
    length = (124 * 50) / icon.number - 1;
    position = 53 + ((124-length-1) * s_screen) / (icon.number / 10 - 4);
   }

  bar( 296, 53, 306, 176, LIGHTGRAY );
  line_horiz( 296, position, 10, WHITE );
  line_vert( 296, position, length, WHITE );
  line_horiz( 297, position+length, 8, DARKGRAY );
  line_vert( 306, position+1, length-1, DARKGRAY );
}


/*****************************
  Í¥Ëa ¬åÈ‚ÑÁ¡e·i Á¡‹¡ÑÁÐe”a.
******************************/
void init_select()
{
  register int i;

  index = 0;
  for( i = s_screen*10; i < icon.number; i ++ )
    index_put_font( i );

  bar( 288, 13, 288+8*2, 13+15, LIGHTGRAY );
  bar( 259, 13, 259+8*2, 13+15, LIGHTGRAY );
  make_str( 259, 13, str(0), WHITE );
  make_str( 288, 13, str(icon.number-1), WHITE );

  display_bar();
}


/****************
  ¤áÌáŸi ¬åÈ‚
*****************/
int select_buffer()
{
  int i;
  int index_x, index_y, ch;
  window_data window;
  int index = 0;

  center_window( 26*3+20, 24+20, &window );

  for( i = 0; i < 3; i ++ )
    copy_put( window.x+10 + i*26, window.y + 10, buffer[i] );
  box( window.x+10, window.y+10, window.x+10+23, window.y+10+23, LIGHTBLUE );

  do{
    ch = get_key();

    index_x = window.x + 10 + index*26;
    index_y = window.y + 10;
    box( index_x, index_y, index_x+23, index_y+23, LIGHTGRAY );

    switch( ch ){
      case ESC   : index = CANCEL;           break;
      case LEFT  : if( index > 0 ) index --; break;
      case RIGHT : if( index < 2 ) index ++; break;
     }

    if( index == CANCEL ) break;
    index_x = window.x + 10 + index*26;
    index_y = window.y + 10;
    box( index_x, index_y, index_x+23, index_y+23, LIGHTBLUE );
   } while( ch != ENTER && ch != ESC );

  close_window( &window );
  return( index );
}


/*****************
  ¤áÌá¡ ¥¢¬a
******************/
void to_buffer( int index )
{
  register int i;
  int buffer_number;
  image_data temp = icon.icon[index];

  buffer_number = select_buffer();
  if( buffer_number == CANCEL ) return;

  for( i = 4; i < 24*24+4; i ++ )
    buffer[buffer_number][i] = temp[i];
}


/******************
  ¤áÌáµA¬á ¥¢¬a
*******************/
void from_buffer( int index )
{
  register int i;
  char buffer_number;
  image_data temp = icon.icon[index];

  buffer_number = select_buffer();
  if( buffer_number == CANCEL ) return;

  for( i = 4; i < 24*24+4; i ++ )
    temp[i] = buffer[buffer_number][i];

  index_put_font( index );
}


/********************
  ´a·¡Å¥·i ÂˆaÐe”a.
*********************/
void insert_icon( int index )
{
  register int i, j;
  int *temp;
  int fill_color = (int)_attr_null_color | (int)_attr_null_color << 8;

  if( icon.number > 98 ) return;

  (char *)temp = icon.icon[icon.number] = farmalloc( 24*24 + 4 );
  temp[0] = temp[1] = 24;

  for( i = icon.number; i > index; i -- ){
    for( j = 4/2; j < (24*24+4)/2; j ++ )
      *((int *)icon.icon[i] + j) = *((int *)icon.icon[i - 1] + j);
    index_put_font( i );
   }

  (char *)temp = icon.icon[index];
  for( i = 4/2; i < 24*24+4/2; i ++ )
    temp[i] = fill_color;
  index_put_font( index );

  icon.number ++;
  bar( 288, 13, 288+8*2, 13+15, LIGHTGRAY );
  make_str( 288, 13, str(icon.number-1), WHITE );
  display_bar();
}


/*********************
  ´a·¡Å¥·i ¬b¹AÐe”a.
**********************/
void delete_icon( int *index )
{
  register int i, j;

  if( icon.number < 2 ) return;
  icon.number --;

  for( i = *index; i < icon.number; i ++ ){

    for( j = 4/2; j < (24*24+4)/2; j ++ )
      *((int *)icon.icon[i] + j ) = *((int *)icon.icon[i + 1] + j);
    index_put_font( i );
   }

  farfree( icon.icon[icon.number] );
  index_put_null( icon.number );

  if( *index > icon.number - 1) (*index) --;
  bar( 288, 13, 288+8*2, 13+15, LIGHTGRAY );
  make_str( 288, 13, str(icon.number-1), WHITE );
  display_bar();
}


/****************************
  ¬¡¶… Í¥ËaŸi ·³b¤h“e”a.
*****************************/
void new_file()
{
  input_filename();
  init_icon();
  open_file();
  s_screen = 0;
  init_select();
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


static void display_sqr()
{
  bar( 259, 13, 259+8*2, 13+15, LIGHTGRAY );
  make_str( 259, 13, str(index), WHITE );
}

void window_up()
{
  int i;

  if( s_screen <= 0 ) return;
  s_screen --;

  scroll_down( 21, 50, 280, 179, 26 );
  for( i = 0; i < 10; i ++ )
    index_put_font( s_screen*10 + i );

  display_bar();
}

void window_down()
{
  int i, j;

  if( (s_screen+5)*10 >= icon.number ) return;
  s_screen ++;

  scroll_up( 21, 50, 280, 179, 26 );
  for( i = 0; i < 10; i ++ ){
    j = (s_screen+4)*10 + i;
    if( j >= icon.number )
     index_put_null( j );
      else
     index_put_font( j );
   }

  display_bar();
}


static void index_select_icon()
{
  int x, y, temp_index;

  if( check_mouse( 22, 51, 279, 178 ) ){
    x = (_mouse.x - 22) / 26;
    y = (_mouse.y - 51) / 26;
    temp_index = (y + s_screen) * 10 + x;
    if( temp_index < icon.number ){
      mouse_cursor_off();
      index_font( LIGHTGRAY );
      index = temp_index;
      index_font( LIGHTBLUE );

      display_sqr();
      mouse_cursor_on();
     }
   }
}


void button_select_icon()
{
  int x, y, old_index;

  x = (int)(index % 10) * 26 + 21;
  y = (int)(index / 10 - s_screen) * 26 + 50;
  if( check_mouse( x, y, x+23, y+23 ) ) put_key( ENTER );

  if( check_mouse( 295, 41, 307, 49 ) ){
    mouse_cursor_off();
    line_horiz( 295, 41, 12, DARKGRAY );
    line_horiz( 296, 42, 10, DARKGRAY );
    line_vert( 295, 42, 7, DARKGRAY );
    line_vert( 296, 43, 5, DARKGRAY );

    line_horiz( 296, 49, 11, WHITE );
    line_horiz( 297, 48, 9, WHITE );
    line_vert( 307, 42, 6, WHITE );
    line_vert( 306, 43, 4, WHITE );

    index_font( LIGHTGRAY );
    old_index = index;
    window_up(); index -= 10;
    if( index < 0 ) index = old_index;
    display_sqr();
    index_font( LIGHTBLUE );
    mouse_cursor_on();
    delay_program( 100 );

    mouse_cursor_off();
    line_horiz( 295, 41, 12, WHITE );
    line_horiz( 296, 42, 10, WHITE );
    line_vert( 295, 42, 7, WHITE );
    line_vert( 296, 43, 5, WHITE );

    line_horiz( 296, 49, 11, DARKGRAY );
    line_horiz( 297, 48, 9, DARKGRAY );
    line_vert( 307, 42, 6, DARKGRAY );
    line_vert( 306, 43, 4, DARKGRAY );
    mouse_cursor_on();
   }
  if( check_mouse( 295, 180, 307, 188 ) ){
    mouse_cursor_off();
    line_horiz( 295, 180, 12, DARKGRAY );
    line_horiz( 296, 181, 10, DARKGRAY );
    line_vert( 295, 181, 7, DARKGRAY );
    line_vert( 296, 182, 5, DARKGRAY );

    line_horiz( 296, 188, 11, WHITE );
    line_horiz( 297, 187, 9, WHITE );
    line_vert( 307, 182, 6, WHITE );
    line_vert( 306, 183, 4, WHITE );

    index_font( LIGHTGRAY );
    old_index = index;
    window_down(); index += 10;
    if( index >= icon.number ) index = old_index;
    display_sqr();
    index_font( LIGHTBLUE );
    mouse_cursor_on();
    delay_program( 100 );

    mouse_cursor_off();
    line_horiz( 295, 180, 12, WHITE );
    line_horiz( 296, 181, 10, WHITE );
    line_vert( 295, 181, 7, WHITE );
    line_vert( 296, 182, 5, WHITE );

    line_horiz( 296, 188, 11, DARKGRAY );
    line_horiz( 297, 187, 9, DARKGRAY );
    line_vert( 307, 181, 6, DARKGRAY );
    line_vert( 306, 182, 4, DARKGRAY );
    mouse_cursor_on();
   }
  if( check_mouse( 160, 11, 199, 30 ) ){
    put_key( F1 );
   }
  if( check_mouse( 205, 11, 244, 30 ) ){
    put_key( ESC );
   }
}


/**************************
  Íe»³Ði Í¥ËaŸi ¬åÈ‚Ðe”a.
***************************/
void select_icon_data()
{
  int old_index;
  char quit_flag = FALSE;
  void (*temp)();
  int ch;

  mouse_cursor_off();

  init_select();
  index_font( LIGHTBLUE );

  mouse_cursor_on();
  _user_handle[0] = index_select_icon;
  _user_handle[1] = button_select_icon;

  do{
    ch = get_key();
    mouse_cursor_off();
    old_index = index;
    index_font( LIGHTGRAY );

    switch( ch ){
      case F1     : select_help();            break;
      case CTRL_S : write_file();             break;
      case CTRL_L : open_file();
                    init_select();
                    index_font( LIGHTBLUE );
                    break;
      case CTRL_N : new_file(&index);         break;

      case '>'    : to_buffer( index );       break;
      case '<'    : from_buffer( index );     break;
      case INS    : insert_icon( index );     break;
      case DEL    : delete_icon(&index);      break;

      case UP     : index -= 10;              break;
      case LEFT   : index --;                 break;
      case RIGHT  : index ++;                 break;
      case DOWN   : index += 10;              break;
      case PG_DN  : index += 10;
                    window_down();            break;
      case PG_UP  : index -= 10;
                    window_up();              break;

      case ENTER  : _user_handle[0] = NULL;
                    editor( index );
                    mouse_cursor_off();
                    load_picture( pic_name, 0 );
                    init_select();
                    index = old_index;
                    _user_handle[0] = index_select_icon;
                    break;

      case ESC    : temp = _user_handle[0];
                    _user_handle[0] = quit_index;
                    _user_handle[1] = quit_click;
                    mouse_cursor_off();
                    push_button( &esc );
                    quit_flag = reply_quit();
                    release_button( &esc );
                    mouse_cursor_on();
                    _user_handle[0] = temp;
                    _user_handle[1] = button_select_icon;
                    break;

     }

    if( index >= icon.number || index < 0 )
      index = old_index;

    display_sqr();

    if( index < s_screen*10 ) window_up();
    if( index >= (s_screen+5)*10 ) window_down();

    index_font( LIGHTBLUE );
    mouse_cursor_on();
   } while( !quit_flag );

  _user_handle[1] = NULL;
}

