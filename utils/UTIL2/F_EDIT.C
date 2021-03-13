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


byte color = BLACK;
int dot_x, dot_y;
int select;
static button_data f1 = { 175, 14, 303, 39, FALSE };

extern char pic_name[80];
extern icon_data icon;        /* Í¥ËaŸi ¸á¸wÐi ¤µi */
extern int index;

void click_any_key();
void button_select_icon();


/****************************
  ·³b¤h·e ¹ÁÎaŸi Îa¯¡Ðe”a.
    ( Í¥Ëa µA—¡Ëa¯¡ )
****************************/
void index_xy( int x, int y, char color )
{
  box( x * 5 + 21, y * 5 + 54, x * 5 + 21+5, y * 5 + 54+5, color );
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
  char *temp = icon.icon[index];

  i = x + y*SIZE_X + 4;
  temp[i] = color;

  bar( x * 5 + 21+1, y * 5 + 54+1, x * 5 + 21+4, y * 5 + 54+4, color );
  put_pixel( x + 71, y + 26, color );
}


/***************************
  Í¥Ëa µA—¡Èá· •¡¶‘ i
     (Í¥Ëa µA—¡Ëa¯¡)
****************************/
void editor_help()
{
  void (*temp1)(), (*temp2)();
  char *message[] = { "¸ñ ¿¢‹¡   - [SPACE]",
                      "‰­¢ ¿¢‹¡ - [C]",
                      "¯aÍ¡·¡—a  - [S]",
                      "¬‚Œi ¬åÈ‚ - [ENTER]",
                      "{‹¡    - [ESC]",
                    };

  temp1 = _user_handle[0];
  temp2 = _user_handle[1];
  _user_handle[0] = NULL;
  _user_handle[1] = click_any_key;

  mouse_cursor_off();
  push_button( &f1 );
  make_message( message, 5 );
  release_button( &f1 );
  mouse_cursor_on();

  _user_handle[0] = temp1;
  _user_handle[1] = temp2;
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
static void display_sqr( int x, int y )
{
  bar( 58, 182, 105, 196, LIGHTGRAY );
  make_str( 58, 182, str(x), WHITE );
  make_str( 78, 182, ",", WHITE );
  make_str( 88, 182, str(y), WHITE );
}


/***************************************
   a¶¯a ¬a¶w¸a ·¡¥EËa Ð…—i·i ¬é¸÷Ðe”a.
****************************************/
static void button_click()
{
  if( check_mouse( 21, 54, 141-1, 174-1 ) ){
    mouse_cursor_off();
    index_xy( dot_x, dot_y, WHITE );
    dot_x = ( _mouse.x - 21 ) / 5;
    dot_y = ( _mouse.y - 54 ) / 5;
    index_xy( dot_x, dot_y, LIGHTBLUE );
    dot_put( dot_x, dot_y, select, color );
    mouse_cursor_on();
   }
  if( check_mouse( 175, 56, 303, 184 ) ){
    mouse_cursor_off();
    index_color( color, WHITE );
    color = (( _mouse.x - 175 ) / 8)*16 + ( _mouse.y - 56 ) / 8;
    index_color( color, LIGHTBLUE );
    mouse_cursor_on();
   }
  if( check_mouse( 71, 26, 94, 49 ) )
    put_key( ESC );
  if( check_mouse( 175, 14, 303, 39 ) ){
    put_key( F1 );
   }
}

static void move_mouse()
{
  int x, y;

  if( check_mouse( 21, 54, 141-1, 174-1 ) ){
    mouse_cursor_off();
    x = ( _mouse.x - 21 ) / 5;
    y = ( _mouse.y - 54 ) / 5;

    display_sqr( x, y );
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
  char *temp = icon.icon[index];

  mouse_cursor_off();

  /* µA—¡Ëa ÑÁ¡e·i Á¡‹¡ÑÁ */
  load_picture( pic_name, 1 );

  for( i = 0; i < 24*24; i ++, x ++ ){
    if( x >= SIZE_X ){
      y ++;
      x = 0;
     }
    dot_put( x, y, index, temp[i+4] );
   }
  dot_x = dot_y = 0;
  display_sqr( dot_x, dot_y );

  select = index;
  _user_handle[0] = move_mouse;
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
    if( dot_x >= SIZE_X ) dot_x = 0;
    if( dot_y >= SIZE_Y ) dot_y = 0;
    if( dot_x < 0 )  dot_x = SIZE_X-1;
    if( dot_y < 0 )  dot_y = SIZE_Y-1;

    if( continue_flag )
      dot_put( dot_x, dot_y, index, color );

    display_sqr( dot_x, dot_y );

    if( spoide_flag ){
      index_color( color, WHITE );
      i = dot_x + dot_y * SIZE_X + 4;
      color = temp[i];
      index_color( color, LIGHTBLUE );
     }

    index_xy( dot_x, dot_y, LIGHTBLUE );
    mouse_cursor_on();
   } while( ch != ESC );

  _user_handle[1] = button_select_icon;
}
