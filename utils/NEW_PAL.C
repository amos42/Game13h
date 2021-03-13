#include <game13h.h>


struct palette_header header = { "Game13h Palette", 1, 1 };

main( int argc, char *argv[] )
{
  int f;
  char pal[256*3];
  char file_name[12 + 1];

  if( argc < 2 ){
    puts( "Usege : NEW_PAL old_palette" );
    exit( 1 );
   }

  strcpy( file_name, argv[1] );
  strcat( file_name, ".PAL" );

  if( (f = _open( file_name, O_RDONLY )) == -1 ){
    puts( "File not found!" );
    exit( 1 );
   }
  _read( f, &header, sizeof( header ) );
  if( strstr( header.head_id, "Game13h Palette" ) ){
    puts( "Already converted!" );
    exit( 2 );
   }
  lseek( f, 0, SEEK_SET );
  _read( f, pal, 256*3 );
  _close( f );

  f = _creat( file_name, FA_ARCH );
  _write( f, &header, sizeof( header ) );
  _write( f, pal, 256*3 );
  _close( f );

  puts( "Done..." );
}
