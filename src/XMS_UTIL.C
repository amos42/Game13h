/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


/**************************************
  ���a�e �A������ �a���i XMS�� �����a.
***************************************/
int store_screen( word page )
{
  int handle;

  handle = xms_alloc( 64000 / 1024 + 1 );
  xms_push( handle, page_pointer( page ), 64000 );

  return( handle );
}


/*****************************
  ��w�E �a���i �a�� �ᐅ�a.
******************************/
void restore_screen( int handle, word page )
{
  xms_pop( handle, page_pointer( page ), 64000 );
}


/************************
  �������i XMS�� �����a.
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
  XMS�A�� �������i �ᐅ�a.
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

