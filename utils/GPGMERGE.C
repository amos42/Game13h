#include <game13h.h>


main( int argc, char *argv[] )
{
  int i;
  int f_1, f_2, f_3;
  struct picture_header header_1, header_2;
  struct pic_chunk_head chunk;
  int number_1, number_2, all_number;
  dword length;
  char *data;
  palette_data pal[256];
  char in_file_1[13], in_file_2[13], out_file[13];

  if( argc < 4 ){
    puts( "Usege : GPGMERGE GPG_file_1 GPG_file_2 Output_GPG_file" );
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
  strcat( out_file, ".GPG" );

  if( (f_1 = _open( in_file_1, O_RDONLY )) == CANCEL ){
    puts( in_file_1 ); cputs( " file Not Found !!" );
    exit( 1 );
   }
  if( (f_2 = _open( in_file_2, O_RDONLY )) == CANCEL ){
    puts( in_file_2 ); cputs( " file Not Found !!" );
    _close( f_1 );
    exit( 1 );
   }
  f_3 = _creat( out_file, FA_ARCH );

  cputs( in_file_1 ); cputs( " + " ); cputs( in_file_2 );
  cputs( " ==> " ); puts( out_file );

  _read( f_1, &header_1, sizeof( header_1 ) );
  _read( f_2, &header_2, sizeof( header_2 ) );
  number_1 = header_1.number;
  number_2 = header_2.number;
  all_number = number_1 + number_2;
  if( all_number > 64 ){
    all_number = 64;
    number_2 = 64 - number_1;
    puts( "Picture too many!" );
    puts( "Second GPG cutted!" );
   }
  length = filelength( f_1 ) - sizeof( header_1 );

  for( i = 0; i < number_2; i ++ )
    header_1.offset[number_1 + i] = header_2.offset[i] + length;

  header_1.number = all_number;
  _write( f_3, &header_1, sizeof( header_1 ) );

  for( i = 0; i < number_1; i ++ ){
    _read( f_1, &chunk, sizeof( chunk ) );
    _write( f_3, &chunk, sizeof( chunk ) );
    if( chunk.pal_flag ){
      _read( f_1, (char *)pal, 256*3 );
      _write( f_3, (char *)pal, 256*3 );
     }
    data = farmalloc( chunk.size );
    _read( f_1, data, chunk.size );
    _write( f_3, data, chunk.size );
    farfree( data );
   }

  for( i = 0; i < number_2; i ++ ){
    _read( f_2, &chunk, sizeof( chunk ) );
    _write( f_3, &chunk, sizeof( chunk ) );
    if( chunk.pal_flag ){
      _read( f_2, pal, 768 );
      _write( f_3, pal, 768 );
     }
    data = farmalloc( chunk.size );
    _read( f_2, data, chunk.size );
    _write( f_3, data, chunk.size );
    farfree( data );
   }

  _close( f_1 );
  _close( f_2 );
  _close( f_3 );
}
