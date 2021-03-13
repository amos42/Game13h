/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/*******************
  ‹aŸ±·i ¡—aÐe”a.
  (¥eÑw LBMÑw¯¢)
********************/
int load_picture( char *file_name, word pic_number )
{
  int f;
  struct picture_header header;
  struct pic_chunk_head chunk;
  char *data;
  palette_data pal_data[256];

  if( (f = _open(file_name, O_RDONLY)) == CANCEL ) return( 1 );
  _read( f, &header, sizeof( header ) );
  if( strcmp( header.head_id, "Game13h Picture" ) ){
    _close( f );
    return( 2 );
   }
  if( pic_number >= header.number ){
    _close( f );
    return( 3 );
   }

  lseek( f, header.offset[pic_number], SEEK_SET );
  _read( f, &chunk, sizeof( chunk ) );

  if( chunk.pal_flag ){
    _read( f, pal_data, 256*3 );
    if( _change_palette_flag )
      change_palette( pal_data );
     else
      memcpy( pal_data, _palette, 256*3 );
   }

  if( chunk.rle_flag ){
    data = farmalloc( chunk.size );
    _read( f, data, chunk.size );
    decode_picture( data, _page_number );
    farfree( data );
   } else
    _read( f, page_pointer( _page_number ), 64000 );

  _close( f );
  return( 0 );
}

