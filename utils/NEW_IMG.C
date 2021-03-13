#include <game13h.h>


struct image_header header = { "Game13h Image__", 1, 1, NULL };

main( int argc, char *argv[] )
{
  register int i;
  int f, size_x, size_y;
  word length;
  char file_name[12 + 1];
  char *data;

  if( argc < 2 ){
    puts( "Usege : NEW_IMG old_icon" );
    exit( 1 );
   }

  strcpy( file_name, argv[1] );
  strcat( file_name, ".IMG" );

  if( (f = _open( file_name, O_RDONLY )) == -1 ){
    puts( "File not found!" );
    exit( 1 );
   }
  _read( f, &header, sizeof( header ) );
  if( strstr( header.head_id, "Game13h Image__" ) ){
    puts( "Already converted!" );
    exit( 2 );
   }

  lseek( f, 0, SEEK_SET );
  _read( f, &size_x, 2 );
  _read( f, &size_y, 2 );
  length = size_x * size_y;
  data = farmalloc( length );
  _read( f, data, length );
  _close( f );

  header.offset[0] = sizeof( header ) + 0;

  f = _creat( file_name, FA_ARCH );
  _write( f, &header, sizeof( header ) );
  _write( f, &size_x, 2 );
  _write( f, &size_y, 2 );
  _write( f, data, length );
  _close( f );

  puts( "Done..." );
  farfree( data );
}
