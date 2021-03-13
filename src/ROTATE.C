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
  ÑÁ¡e¬wµA¬á ¡ÉA·¡­e·i ŠÑeÐe”a.
**********************************/
void rotate( int start_x, int start_y, int end_x, int end_y, char direct, word step )
{
  image_data image;

  switch( direct ){
    case 'u' : get_image( start_x, start_y, end_x, start_y+step-1, &image );
               scroll_up( start_x, start_y, end_x, end_y, step );
               copy_put( start_x, end_y-step+1, image );
               break;
    case 'd' : get_image( start_x, end_y-step+1, end_x, end_y, &image );
               scroll_down( start_x, start_y, end_x, end_y, step );
               copy_put( start_x, start_y, image );
               break;
    case 'l' : get_image( start_x, start_y, start_x+step-1, end_y, &image );
               scroll_left( start_x, start_y, end_x, end_y, step );
               copy_put( end_x-step+1, start_y, image );
               break;
    case 'r' : get_image( end_x-step+1, start_y, end_x, end_y,     &image );
               scroll_right( start_x, start_y, end_x, end_y, step );
               copy_put( start_x, start_y, image );
               break;
   }

  farfree( image );
}
