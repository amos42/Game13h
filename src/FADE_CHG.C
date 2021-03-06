/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


/***********************************
  �e �i�A�a�i �a�e �i�A�a�� �a���a.
************************************/
void fade_change( palette_data *source, palette_data *target, word step, word milli_sec )
{
  register int i, j;
  char *s_color, *t_color;
  palette_data temp[256];

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    s_color = (char *)source;
    t_color = (char *)target;

    for( j = 0; j < 256; j ++ ){
      temp[j].red   = *s_color + (*t_color++ - *s_color) * i / step; s_color++;
      temp[j].green = *s_color + (*t_color++ - *s_color) * i / step; s_color++;
      temp[j].blue  = *s_color + (*t_color++ - *s_color) * i / step; s_color++;
     }

    change_palette( temp );
   }
}


/******************************
  fade_in()�i �����e ��З�e�a.
*******************************/
void fade_change_part(palette_data *source,palette_data *target,word step,word milli_sec,byte start, word change)
{
  register int i, j;
  char *s_color, *t_color;
  palette_data temp[256];

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    s_color = (char *)&source[ start ];
    t_color = (char *)&target[ start ];

    for( j = 0; j < change; j ++ ){
      temp[j].red   = *s_color + (*t_color++ - *s_color) * i / step; s_color++;
      temp[j].green = *s_color + (*t_color++ - *s_color) * i / step; s_color++;
      temp[j].blue  = *s_color + (*t_color++ - *s_color) * i / step; s_color++;
     }

    change_palette_part( temp, start, change );
   }
}


/******************************
  fade_change�i �a�S�a�� ��З
*******************************/
void fade_change_step( palette_data *source, palette_data *target, word step )
{
  register int i;
  char *s_color, *t_color;
  palette_data temp[256];

  s_color = (char *)source;
  t_color = (char *)target;

  for( i = 0; i < 256; i ++ ){
    temp[i].red   = *s_color + (*t_color++ - *s_color) * step >> 6; s_color++;
    temp[i].green = *s_color + (*t_color++ - *s_color) * step >> 6; s_color++;
    temp[i].blue  = *s_color + (*t_color++ - *s_color) * step >> 6; s_color++;
   }

  change_palette( temp );
}

