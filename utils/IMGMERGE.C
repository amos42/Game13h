#include <game13h.h>


main( int argc, char *argv[] )
{
  int i;
  int f_1, f_2, f_3;
  struct image_header header_1, header_2;
  int size_x, size_y, image_size;
  int number_1, number_2, all_number;
  dword length;
  image_data data;
  char in_file_1[13], in_file_2[13], out_file[13];

  if( argc < 4 ){
    puts( "Usege : IMGMERGE IMG_file_1 IMG_file_2 Output_IMG_file" );
    exit( 1 );
   }

  strcpy( in_file_1, argv[1] );
  strcpy( in_file_2, argv[2] );
  strcpy( out_file, argv[3] );
  strupr( in_file_1 );
  strupr( in_file_2 );
  strupr( out_file );
  strcat( in_file_1, ".IMG" );
  strcat( in_file_2, ".IMG" );
  strcat( out_file, ".IMG" );

  cputs( in_file_1 ); cputs( " + " ); cputs( in_file_2 );
  cputs( " ==> " ); puts( out_file );

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

  _read( f_1, &header_1, sizeof( header_1 ) );
  _read( f_2, &header_2, sizeof( header_2 ) );
  number_1 = header_1.number;
  number_2 = header_2.number;
  all_number = number_1 + number_2;
  if( all_number > 64 ){
    all_number = 64;
    number_2 = 64 - number_1;
    puts( "Image too many!" );
    puts( "Second IMG cutted!" );
   }
  length = filelength( f_1 ) - sizeof( header_1 );

  for( i = 0; i < number_2; i ++ )
    header_1.offset[number_1 + i] = header_2.offset[i] + length;

  header_1.number = all_number;
  _write( f_3, &header_1, sizeof( header_1 ) );

  for( i = 0; i < number_1; i ++ ){
    _read( f_1, &size_x, 2 );
    _read( f_1, &size_y, 2 );
    _write( f_3, &size_x, 2 );
    _write( f_3, &size_y, 2 );
    image_size = size_x * size_y;
    data = farmalloc( image_size );
    _read( f_1, data, image_size );
    _write( f_3, data, image_size );
    farfree( data );
   }

  for( i = 0; i < number_2; i ++ ){
    _read( f_2, &size_x, 2 );
    _read( f_2, &size_y, 2 );
    _write( f_3, &size_x, 2 );
    _write( f_3, &size_y, 2 );
    image_size = size_x * size_y;
    data = farmalloc( image_size );
    _read( f_2, data, image_size );
    _write( f_3, data, image_size );
    farfree( data );
   }

  _close( f_1 );
  _close( f_2 );
  _close( f_3 );
}
