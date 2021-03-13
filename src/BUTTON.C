/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/*****************
  ¤áËe·i ‹aŸ¥”a.
******************/
void draw_button( int start_x, int start_y, int end_x, int end_y, button_data *button )
{
  button_data temp;

  bar( start_x+1, start_y+1, end_x-1, end_y-1, LIGHTGRAY );

  line_horiz( start_x,   start_y,   end_x-start_x+1, WHITE );
  line_vert(  start_x,   start_y+1, end_y-start_y,   WHITE );
  line_horiz( start_x+1, end_y,     end_x-start_x,   DARKGRAY );
  line_vert(  end_x,     start_y+1, end_y-start_y-1, DARKGRAY );

  temp.start_x = start_x;
  temp.start_y = start_y;
  temp.end_x = end_x;
  temp.end_y = end_y;
  temp.push_flag = FALSE;

  *button = temp;
}


/*****************
  ¤áËe·i ’Ÿe”a.
******************/
void push_button( button_data *button )
{
  button_data temp = *button;

  if( temp.push_flag ) return;

  line_horiz( temp.start_x,   temp.start_y,   temp.end_x-temp.start_x+1, DARKGRAY );
  line_vert(  temp.start_x,   temp.start_y+1, temp.end_y-temp.start_y,   DARKGRAY );
  line_horiz( temp.start_x+1, temp.end_y,     temp.end_x-temp.start_x,   LIGHTGRAY );
  line_vert(  temp.end_x,     temp.start_y+1, temp.end_y-temp.start_y-1, LIGHTGRAY );

  button->push_flag = TRUE;
}


/*************************
  ¤áËe·i ¶¥œ”¡ •©Ÿ¥”a.
**************************/
void release_button( button_data *button )
{
  button_data temp = *button;

  if( !temp.push_flag ) return;

  line_horiz( temp.start_x,   temp.start_y,   temp.end_x-temp.start_x+1, WHITE );
  line_vert(  temp.start_x,   temp.start_y+1, temp.end_y-temp.start_y,   WHITE );
  line_horiz( temp.start_x+1, temp.end_y,     temp.end_x-temp.start_x,   DARKGRAY );
  line_vert(  temp.end_x,     temp.start_y+1, temp.end_y-temp.start_y-1, DARKGRAY );

  button->push_flag = FALSE;
}
