/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


static char win[9][16*16 + 4];


/**************************
  ·A¸á ¶å•¡¶Ÿi ¡—aÐe”a.
***************************/
int load_user_window( char *file_name )
{
  int i, f;
  struct window_header header;

  if( (f = _open(file_name, O_RDONLY)) == CANCEL ) return( 1 );
  _read( f, &header, sizeof( header ) );
  if( strcmp( header.head_id, "Game13h Window_" ) ){
    _close( f );
    return( 2 );
   }

  for( i = 0; i < 9; i ++ ){
    win[i][0] = win[i][2] = 16;
    win[i][1] = win[i][3] = 0;
    _read( f, &win[i][4], 16*16 );
   }

  _close( f );
  return( 0 );
}


/************************
  ·A¸á ¶å•¡¶Ÿi ‹aŸ¥”a.
*************************/
int draw_user_window( int x, int y, word size_x, word size_y )
{
  int i, j;

  if( size_x < 2 || size_y < 2 ) return(1);
  if( x + size_x*16 >= 320 || y + size_y*16 >= 200 ) return(2);

  char_put( x, y, win[0] );
  for( i = 1; i < size_x - 1; i ++ )
    char_put( x + i*16, y, win[1] );
  char_put( x + i*16, y, win[2] );
  y += 16;

  for( i = 0; i < size_y - 2; i ++ ){
    char_put( x, y, win[3] );
    for( j = 1; j < size_x - 1; j ++ )
      char_put( x + j*16, y, win[4] );
    char_put( x + j*16, y, win[5] );
    y += 16;
   }

  char_put( x, y, win[6] );
  for( i = 1; i < size_x - 1; i ++ )
    char_put( x + i*16, y, win[7] );
  char_put( x + i*16, y, win[8] );

  return(0);
}


/**********************
  ·A¸á ¶å•¡¶Ÿi µe”a.
***********************/
int open_user_window( int x, int y, word size_x, word size_y, window_data *window )
{
  word x_size, y_size;

  window->x = x;
  window->y = y;

  x_size = size_x << 4;
  if( x_size < 16 || x_size > 319 ) return( 1 );
  y_size = size_y << 4;
  if( y_size < 16 || y_size > 199 ) return( 2 );

  get_image( x, y, x + x_size - 1, y + y_size - 1, &(window->image) );
  draw_user_window( x, y, size_x, size_y );

  return( 0 );
}


/*****************************
  º—´wµA ·A¸á ¶å•¡¶Ÿi µe”a.
******************************/
int center_user_window( word size_x, word size_y, window_data *window )
{
  int x, y;

  x = ( H_RES - (size_x << 4) ) >> 1;
  y = ( V_RES - (size_y << 4) ) >> 1;

  return( open_user_window( x, y, size_x, size_y, window ) );
}

