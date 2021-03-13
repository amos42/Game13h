/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/***************************************
  —¡¯aÇaµA¬á ÌiAËa ¸÷¥¡Ÿi ·ª´á —i·¥”a.
****************************************/
int load_palette( char *pal_name, word pal_number )
{
  int f;
  struct palette_header header;
  palette_data pal_info[256];

  if( (f = _open( pal_name, O_RDONLY )) == CANCEL ) return( 1 );
  _read( f, &header, sizeof( header ) );
  if( strcmp( header.head_id, "Game13h Palette" ) ){
    _close( f );
    return( 2 );
   }
  if( pal_number >= header.number ){
    _close( f );
    return( 3 );
   }

  lseek( f, pal_number * 768, SEEK_CUR );
  _read( f, pal_info, 768 );
  _close( f );

  if( _change_palette_flag )
    change_palette( pal_info );
   else
    memcpy( pal_info, _palette, 256*3 );

  return( 0 );
}


/*********************
  µ¡¤áœ“·i ŠÑeÐe”a.
**********************/
int load_overlab( char *file_name, word page, palette_data *pal_1, palette_data *pal_2 )
{
  int f;
  struct overlab_header header;
  char *image;

  if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 1 );

  _read( f, &header, sizeof( header ) );
  if( strcmp( header.head_id, "Game13h OverLab" ) ){
    _close( f );
    return( 2 );
   }
  _read( f, pal_1, 256*3 );
  _read( f, pal_2, 256*3 );

  if( header.rle_flag ){
    image = farmalloc( header.pic_size );
    _read( f, image, header.pic_size );
    decode_picture( image, page );
    farfree( image );
   } else
    _read( f, page_pointer( page ), 64000 );

  _close( f );
  return( 0 );
}

