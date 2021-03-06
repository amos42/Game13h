/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


/**************************
  �A���a-�a���i ���e�e�a.
***************************/
void fade_out( byte target_color, word step, word milli_sec )
{
  register int i, j;
  char t_r, t_g, t_b;
  char *s_color;
  palette_data temp[256];

  t_r = _palette[target_color].red;
  t_g = _palette[target_color].green;
  t_b = _palette[target_color].blue;

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    s_color = (char *)_palette;

    for( j = 0; j < 256; j ++ ){
      temp[j].red   = *s_color + (t_r - *s_color) * i / step; s_color++;
      temp[j].green = *s_color + (t_g - *s_color) * i / step; s_color++;
      temp[j].blue  = *s_color + (t_b - *s_color) * i / step; s_color++;
     }

    change_palette( temp );
   }
}


/*******************************
  fade_out()�i �����e ��З�e�a.
********************************/
void fade_out_part( byte target_color, word step, word milli_sec, byte start, word change )
{
  register int i, j;
  char t_r, t_g, t_b;
  char *s_color;
  palette_data temp[256];

  t_r = _palette[target_color].red;
  t_g = _palette[target_color].green;
  t_b = _palette[target_color].blue;

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    s_color = (char *)&_palette[ start ];

    for( j = 0; j < change; j ++ ){
      temp[j].red   = *s_color + (t_r - *s_color) * i / step; s_color++;
      temp[j].green = *s_color + (t_g - *s_color) * i / step; s_color++;
      temp[j].blue  = *s_color + (t_b - *s_color) * i / step; s_color++;
     }

    change_palette_part( temp, start, change );
   }
}


/**************************
  fade_out�i �a�S�a�� ��З
***************************/
void fade_out_step( byte target_color, word step )
{
  register int i;
  char t_r, t_g, t_b;
  char *s_color;
  palette_data temp[256];

  t_r = _palette[target_color].red;
  t_g = _palette[target_color].green;
  t_b = _palette[target_color].blue;

  s_color = (char *)_palette;

  for( i = 0; i < 256; i ++ ){
    temp[i].red   = *s_color + (t_r - *s_color) * step >> 6; s_color++;
    temp[i].green = *s_color + (t_g - *s_color) * step >> 6; s_color++;
    temp[i].blue  = *s_color + (t_b - *s_color) * step >> 6; s_color++;
   }

  change_palette( temp );
}


/**************************************
  RGB�����a�� �A���a-�a���i ���e�e�a.
***************************************/
void fade_out_rgb( byte red, byte green, byte blue, word step, word milli_sec )
{
  register int i, j;
  char *s_color;
  palette_data temp[256];

  for( i = 1; i <= step; i ++ ){
    if( milli_sec ) delay_program( milli_sec );
    s_color = (char *)_palette;

    for( j = 0; j < 256; j ++ ){
      temp[j].red   = *s_color + (red   - *s_color) * i / step; s_color++;
      temp[j].green = *s_color + (green - *s_color) * i / step; s_color++;
      temp[j].blue  = *s_color + (blue  - *s_color) * i / step; s_color++;
     }

    change_palette( temp );
   }
}

