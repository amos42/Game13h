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
  ÌiAËaŸi ¡¡– Ób¤‚·a¡ ¤aŽ…”a.
**********************************/
void gray_palette( word gray_color )
{
  register int i;
  int r, g, b;
  char avr;
  palette_data pal_array[256];

  for( i = 0; i < 256; i ++ ){
    r = (int)_palette[i].red   * 30;
    g = (int)_palette[i].green * 59;
    b = (int)_palette[i].blue  * 11;
    avr = (char)( (r + g + b) / 100 );
    switch( gray_color ){
      case BLACK : pal_array[i].red   = avr;
                   pal_array[i].green = avr;
                   pal_array[i].blue  = avr;
                   break;
      case RED   : pal_array[i].red   = avr;
                   pal_array[i].green = 0;
                   pal_array[i].blue  = 0;
                   break;
      case GREEN : pal_array[i].red   = 0;
                   pal_array[i].green = avr;
                   pal_array[i].blue  = 0;
                   break;
      case BLUE  : pal_array[i].red   = 0;
                   pal_array[i].green = 0;
                   pal_array[i].blue  = avr;
                   break;
     }
   }

  change_palette( pal_array );
}


/*********************************
  ÌiAËaŸi ¡¡– Ób¤‚·a¡ ¤aŽ…”a.
**********************************/
void gray_palette_array( word gray_color, palette_data *pal_array )
{
  register int i;
  int r, g, b;
  char avr;

  for( i = 0; i < 256; i ++ ){
    r = (int)_palette[i].red   * 30;
    g = (int)_palette[i].green * 59;
    b = (int)_palette[i].blue  * 11;
    avr = (char)( (r + g + b) / 100 );
    switch( gray_color ){
      case BLACK : pal_array[i].red   = avr;
                   pal_array[i].green = avr;
                   pal_array[i].blue  = avr;
                   break;
      case RED   : pal_array[i].red   = avr;
                   pal_array[i].green = 0;
                   pal_array[i].blue  = 0;
                   break;
      case GREEN : pal_array[i].red   = 0;
                   pal_array[i].green = avr;
                   pal_array[i].blue  = 0;
                   break;
      case BLUE  : pal_array[i].red   = 0;
                   pal_array[i].green = 0;
                   pal_array[i].blue  = avr;
                   break;
     }
   }
}

