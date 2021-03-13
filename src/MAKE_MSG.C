/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/*********************************
  ÑÁ¡e· º—´wµA ¶å•¡¶Ÿi µi‰¡
  ¡A­A»¡Ÿi Îa¯¡Ðe Ò, Ç¡· ·³b·¡
  ·¶·a¡e ”a¯¡ ”h“e”a.
**********************************/
int make_message( char *message[], word row )
{
  register int i, col = 0;
  window_data window;
  int x, y;
  word temp;
  word size_x, size_y;

  if( row > 9 ) return( 1 );
  for( i = 0; i < row; i ++ ){
    temp = strlen( message[i] );
    if( col < temp ) col = temp;
   }
  if( col > 37 ) return( 2 );

  size_y = row * 18 + 14;
  size_x = col * 8  + 16;

  if( center_window( size_x, size_y, &window ) ) return( 3 );

  for( i = 0; i < row; i ++ )
    make_str_double( window.x + 8, window.y + 8 + i*18, message[i], WHITE, 1 );
  get_key();

  close_window( &window );
  return( 0 );
}
