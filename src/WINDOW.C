/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/**************************
  ÑÁ¡eµA ¶¥•¡¶Ÿi ‹aŸ¥”a.
***************************/
int draw_window( int start_x, int start_y, int end_x, int end_y )
{
  int x_size, y_size;

  x_size = end_x - start_x + 1;
  if( x_size < 13 || x_size > 320 ) return( 1 );
  y_size = end_y - start_y + 1;
  if( y_size < 13 || y_size > 200 ) return( 2 );

  line_horiz( start_x,   start_y,   x_size,   WHITE );
  line_horiz( start_x+1, start_y+1, x_size-2, WHITE );
  line_vert(  start_x,   start_y+1, y_size-1, WHITE );
  line_vert(  start_x+1, start_y+2, y_size-2, WHITE );
  line_horiz( start_x+1, end_y,     x_size-1, DARKGRAY );
  line_horiz( start_x+2, end_y-1,   x_size-2, DARKGRAY );
  line_vert(  end_x,     start_y+1, y_size-2, DARKGRAY );
  line_vert(  end_x-1,   start_y+2, y_size-4, DARKGRAY );
  bar( start_x+2, start_y+2, end_x-2, end_y-2, LIGHTGRAY );
  line_horiz( start_x+5, start_y+5, x_size-10, DARKGRAY );
  line_vert(  start_x+5, start_y+6, y_size-11, DARKGRAY );
  line_horiz( start_x+6, end_y-5,   x_size-11, WHITE );
  line_vert(  end_x-5,   start_y+6, y_size-12, WHITE );

  return( 0 );
}


/************************
  ÑÁ¡eµA ¶å•¡¶Ÿi µe”a.
*************************/
int open_window( int start_x, int start_y, int end_x, int end_y, window_data *window )
{
  int x_size, y_size;

  window->x = start_x;
  window->y = start_y;

  x_size = end_x - start_x + 1;
  if( x_size < 13 || x_size > 319 ) return( 1 );
  y_size = end_y - start_y + 1;
  if( y_size < 13 || y_size > 199 ) return( 2 );

  get_image( start_x, start_y, end_x, end_y, &(window->image) );
  draw_window( start_x, start_y, end_x, end_y );

  return( 0 );
}


/****************************
  ÑÁ¡e º—´wµA ¶å•¡¶Ÿi µe”a.
*****************************/
int center_window( word size_x, word size_y, window_data *window )
{
  int start_x, start_y, end_x, end_y;

  start_x = ( H_RES - size_x ) >> 1;
  start_y = ( V_RES - size_y ) >> 1;
  end_x   = ( H_RES + size_x ) >> 1;
  end_y   = ( V_RES + size_y ) >> 1;

  return( open_window( start_x, start_y, end_x, end_y, window ) );
}


/************************************
  ¶å•¡¶Ÿi ”h‰¡ ¡A¡¡Ÿ¡Ÿi Ð¤w¯¡Ç¥”a.
*************************************/
void close_window( window_data *window )
{
  copy_put( window->x, window->y, window->image );
  farfree( window->image );
}

