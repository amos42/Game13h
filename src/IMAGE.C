/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


/*****************************************
  ���a�a�A�� ������ �A����i ����i���a.
******************************************/
int load_image( char *file_name, image_data *image, word image_number )
{
  int f;
  word size_x, size_y, image_size;
  struct image_header header;
  int *temp;

  if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 1 );

  _read( f, &header, sizeof( header ) );
  if( strcmp( header.head_id, "Game13h Image__" ) ){
    _close( f );
    return( 2 );
   }
  if( image_number >= header.number ){
    _close( f );
    return( 3 );
   }

  lseek( f, header.offset[ image_number ], SEEK_SET );
  _read( f, &size_x, 2 ); _read( f, &size_y, 2 );

  image_size = size_x * size_y;

  temp = (int *)*image = farmalloc( image_size + 4 );
  *temp++ = size_x;
  *temp++ = size_y;

  _read( f, temp, image_size );
  _close( f );

  return( 0 );
}

