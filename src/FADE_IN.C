/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/*************************
  ÍA·¡—a-·¥·i ŠÑeÐe”a.
**************************/
void fade_in( byte source_color, word step, word milli_sec )
{
  register int i, j;
  char s_r, s_g, s_b;
  char *t_color;
  palette_data temp[256];

  s_r = _palette[source_color].red;
  s_g = _palette[source_color].green;
  s_b = _palette[source_color].blue;

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    t_color = (char *)_palette;

    for( j = 0; j < 256; j ++ ){
      temp[j].red   = s_r + (*t_color - s_r) * i / step; t_color++;
      temp[j].green = s_g + (*t_color - s_g) * i / step; t_color++;
      temp[j].blue  = s_b + (*t_color - s_b) * i / step; t_color++;
     }

    change_palette( temp );
   }
}


/******************************
  fade_in()·i ·©¦ e »¥Ð—Ðe”a.
*******************************/
void fade_in_part( byte source_color, word step, word milli_sec, byte start, word change )
{
  register int i, j;
  char s_r, s_g, s_b;
  char *t_color;
  palette_data temp[256];

  s_r = _palette[source_color].red;
  s_g = _palette[source_color].green;
  s_b = _palette[source_color].blue;

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    t_color = (char *)&_palette[ start ];

    for( j = 0; j < change; j ++ ){
      temp[j].red   = s_r + (*t_color++ - s_r) * i / step;
      temp[j].green = s_g + (*t_color++ - s_g) * i / step;
      temp[j].blue  = s_b + (*t_color++ - s_b) * i / step;
     }

    change_palette_part( temp, start, change );
   }
}


/**************************
  fade_in·i ¯aÉS·a¡ »¥Ð—
***************************/
void fade_in_step( byte source_color, word step )
{
  register int i;
  char s_r, s_g, s_b;
  char *t_color;
  palette_data temp[256];

  s_r = _palette[source_color].red;
  s_g = _palette[source_color].green;
  s_b = _palette[source_color].blue;

  t_color = (char *)_palette;

  for( i = 0; i < 256; i ++ ){
    temp[i].red   = s_r + (*t_color++ - s_r) * step >> 6;
    temp[i].green = s_g + (*t_color++ - s_g) * step >> 6;
    temp[i].blue  = s_b + (*t_color++ - s_b) * step >> 6;
   }

  change_palette( temp );
}


/************************************
  RGB­¢¬÷·a¡ ÍA·¡—a-·¥·i ŠÑeÐe”a.
*************************************/
void fade_in_rgb( byte red, byte green, byte blue, word step, word milli_sec )
{
  register int i, j;
  char *t_color;
  palette_data temp[256];

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    t_color = (char *)_palette;

    for( j = 0; j < 256; j ++ ){
      temp[j].red   = red   + (*t_color++ - red)   * i / step;
      temp[j].green = green + (*t_color++ - green) * i / step;
      temp[j].blue  = blue  + (*t_color++ - blue)  * i / step;
     }

    change_palette( temp );
   }
}

