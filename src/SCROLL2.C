/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/********************************
  ÑÁ¡e· ·©¦¦…·i ¯aÇa© ¯¡Ç¥”a.
*********************************/
void scroll( int start_x, int start_y, int end_x, int end_y, char direct, word step )
{
  switch( direct ){
    case 'u' : scroll_up(    start_x, start_y, end_x, end_y, step ); break;
    case 'd' : scroll_down(  start_x, start_y, end_x, end_y, step ); break;
    case 'l' : scroll_left(  start_x, start_y, end_x, end_y, step ); break;
    case 'r' : scroll_right( start_x, start_y, end_x, end_y, step ); break;
   }
}


/***************************
  ¯aÇa© Ò ¸e¬w·i »¡¶…”a.
****************************/
void scroll_clear( int s_x, int s_y, int e_x, int e_y, char direct, word step )
{
  switch( direct ){
    case 'u' : scroll_up( s_x, s_y, e_x, e_y, step );
               bar( s_x, e_y - step + 1, e_x, e_y, _attr_back_color );
               break;
    case 'd' : scroll_down( s_x, s_y, e_x, e_y, step );
               bar( s_x, s_y, e_x, s_y + step - 1, _attr_back_color );
               break;
    case 'l' : scroll_left( s_x, s_y, e_x, e_y, step );
               bar( e_x - step + 1, s_y, e_x, e_y, _attr_back_color );
               break;
    case 'r' : scroll_right( s_x, s_y, e_x, e_y, step );
               bar( s_x, s_y, s_x + step - 1, e_y, _attr_back_color );
               break;
   }
}

