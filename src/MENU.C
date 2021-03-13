/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


static void disp_menu( int x, int y, char *message[], int col, int number )
{
  int i;

  bar( x+8, y+8, x+8 + col, y+8 + number*20 - 4, LIGHTGRAY );

  for( i = 0; i < number; i ++ )
    make_str_double( x+8, y+8 + i*20, message[i], WHITE, 1 );
}

/************************
    ¡A“A ¹A‘AA·¡Èá.
*************************/
int gen_menu( char *message[], int max_row, int disp_row )
{
  int i;
  int col = 0;
  int temp;
  window_data window;
  int index = 0, s_index = 0;
  int ch;

  if( disp_row > 9 ) return( CANCEL );
  for( i = 0; i < max_row; i ++ ){
    temp = strlen( message[i] );
    if( col < temp ) col = temp;
   }
  if( col > 37 ) return( CANCEL );
  col *= 8;

  center_window( col + 17, disp_row*20 + 11, &window );

  disp_menu( window.x, window.y, &message[0], col, disp_row );
  box( window.x+7, window.y+7, window.x+7+3 + col, window.y+7 + 17, LIGHTBLUE );
  max_row --;

  do{
    ch = get_key();

    box( window.x+7, window.y+7 + s_index*20, window.x+7+3 + col, window.y+7 + s_index*20 + 17, LIGHTGRAY );

    switch( ch ){
      case UP   : if( index > 0 ){
                    index --; s_index --;
                    if( s_index < 0 ){
                      s_index = 0;
                      disp_menu( window.x, window.y, &message[index - s_index], col, disp_row );
                     }
                   }
                  break;
      case DOWN : if( index < max_row ){
                    index ++; s_index ++;
                    if( s_index >= disp_row ){
                      s_index = disp_row - 1;
                      disp_menu( window.x, window.y, &message[index - s_index], col, disp_row );
                     }
                   }
                  break;
     }

    box( window.x+7, window.y+7 + s_index*20, window.x+7+3 + col, window.y+7 + s_index*20 + 17, LIGHTBLUE );

   } while( ch != ENTER && ch != SPACE && ch != ESC );

  close_window( &window );

  if( ch == ESC )
    return( CANCEL );
   else
    return( index );
}

