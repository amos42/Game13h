#include <game13h.h>


struct icon_header header = { "Game13h Icon___", 1, 0, 16, 16 };

main( int argc, char *argv[] )
{
  int f, icon_number;
  word length;
  char file_name[12 + 1];
  char *data;

  if( argc < 2 ){
    puts( "Usege : NEW_ICO old_icon" );
    exit( 1 );
   }

  strcpy( file_name, argv[1] );
  strcat( file_name, ".ICO" );

  if( (f = _open( file_name, O_RDONLY )) == -1 ){
    puts( "File not found!" );
    exit( 1 );
   }
  _read( f, &header, sizeof( header ) );
  if( strstr( header.head_id, "Game13h Icon___" ) ){
    puts( "Already converted!" );
    exit( 2 );
   }

  lseek( f, 0, SEEK_SET );
  _read( f, &header.number, 2 );
  length = filelength( f ) - 2;
  data = farmalloc( length );
  _read( f, data, length );
  _close( f );

  f = _creat( file_name, FA_ARCH );
  _write( f, &header, sizeof( header ) );
  _write( f, data, length );
  _close( f );

  puts( "Done..." );
  farfree( data );
}

