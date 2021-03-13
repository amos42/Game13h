#include <game13h.h>
#include <dir.h>


struct overlab_header file_head = { "Game13h OverLab", 1, TRUE, 0 };

main( int argc, char *argv[] )
{
  int f;
  word i, j, k;
  char *source, *target, *image;
  palette_data temp[16], pal_1[256], pal_2[256];
  char in_file_1[13], in_file_2[13], out_file[13];
  struct ffblk ff;
  int exit_flag = FALSE;

  if( argc < 4 ){
    puts( "Usege : GPG2GOL GPG_file_1 GPG_file_2 Output_file" );
    exit( 1 );
   }

  strcpy( in_file_1, argv[1] );
  strcpy( in_file_2, argv[2] );
  strcpy( out_file, argv[3] );
  strupr( in_file_1 );
  strupr( in_file_2 );
  strupr( out_file );
  strcat( in_file_1, ".GPG" );
  strcat( in_file_2, ".GPG" );
  strcat( out_file, ".GOL" );
  if( findfirst( in_file_1, &ff, FA_ARCH ) ){
    cputs( in_file_1 ); cputs( " file Not Found !!\n\r" );
    exit_flag = TRUE;
   }
  if( findfirst( in_file_2, &ff, FA_ARCH ) ){
    cputs( in_file_2 ); cputs( " file Not Found !!\n\r" );
    exit_flag = TRUE;
   }
  if( exit_flag ) exit( 1 );

  init_page( 2 );

  _page_number = 1;
  set_monitor( OFF );
  load_picture( in_file_1, 0 );
  fix_palette_array( (palette_data *)temp, 0, 16 );
  for( i = 0; i < 16; i ++ )
    for( j = 0; j < 16; j ++ )
      pal_1[ j*16 + i ] = temp[j];

  _page_number = 2;
  load_picture( in_file_2, 0 );
  fix_palette_array( temp, 0, 16 );
  for( i = 0; i < 16; i ++ )
    for( j = 0; j < 16; j ++ )
      pal_2[ i*16 +j ] = temp[j];
  set_monitor( ON );
  _AX = 0x0003;
  __int__( 0x10 );  /* For palette restore */
  cputs( in_file_1 ); cputs( " + " ); cputs( in_file_2 );
  cputs( " ==> " ); cputs( out_file );

  source = page_pointer( 1 );
  target = page_pointer( 2 );

  for( i = 0; i < 64000; i ++ ){
    *(source + i) <<= 4;
    *(target + i) &= 0x0F;
    *(source + i) |= *(target + i);
   }

  f = _creat( out_file, FA_ARCH );

  file_head.pic_size = incode_picture( &image, 1 );
  if( !file_head.pic_size ){
    file_head.rle_flag = FALSE;
    file_head.pic_size = 64000;
   }
  _write( f, &file_head, sizeof( file_head ) );
  _write( f, pal_1, 256*3 );
  _write( f, pal_2, 256*3 );
  if( file_head.rle_flag ){
    _write( f, image, file_head.pic_size );
    farfree( image );
   } else
    _write( f, source, 64000 );

  _close( f );
  close_page();
}
