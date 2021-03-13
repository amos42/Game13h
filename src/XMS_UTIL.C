/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/**************************************
  ¶¥Ða“e ÍA·¡»¡· ‹aŸ±·i XMS¡ µ«‹¥”a.
***************************************/
int store_screen( word page )
{
  int handle;

  handle = xms_alloc( 64000 / 1024 + 1 );
  xms_push( handle, page_pointer( page ), 64000 );

  return( handle );
}


/*****************************
  ¸á¸w–E ‹aŸ±·i ”a¯¡ Œá…”a.
******************************/
void restore_screen( int handle, word page )
{
  xms_pop( handle, page_pointer( page ), 64000 );
}


/************************
  ·¡£¡»¡Ÿi XMS¡ µ«‹¥”a.
*************************/
int store_image( image_data image )
{
  int size, xms_size;
  int handle;

  size = image_size( image );
  xms_size = size >> 10;
  if( size & 0x03FF ) xms_size ++;

  handle = xms_alloc( xms_size );
  xms_push( handle, image, size );

  farfree( image );
  return( handle );
}


/**************************
  XMSµA¬á ·¡£¡»¡Ÿi Œá…”a.
***************************/
void restore_image( int handle, image_data *image )
{
  int size[2], image_size;

  xms_pop( handle, (char *)size, 4 );

  image_size = size[0] * size[1] + 4;
  *image = farmalloc( image_size );

  xms_pop( handle, *image, image_size );
  xms_free( handle );
}

