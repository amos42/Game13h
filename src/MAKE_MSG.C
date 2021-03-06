/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


/*********************************
  ���e�� ���w�A �啡���i �i��
  �A�A���i �a���e ҁ, ǡ�� ���b��
  ���a�e �a�� �h�e�a.
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
