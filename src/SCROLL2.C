/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


/********************************
  ���e�� �������i �a�a�� ��ǥ�a.
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
  �a�a�� ҁ �e�w�i �����a.
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

