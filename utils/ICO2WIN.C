/*********************************

        >> ICO2WIN.C <<

	       - º‰w£¥ -

**********************************/
#include <game13h.h>


struct icon_header head_1   = { "Game13h Icon___", 1, 0, 16, 16 };
struct window_header head_2 = { "Game13h Window_", 1 };

main( int argc, char *argv[] )
{
  int i, f;
  char in_filename[13], out_filename[13];
  icon_data icon;

  if( argc < 2 ){
    cputs("Usage : ICO2WIN <ICO file name>\n\r");
    exit( 0 );
   }

  strcpy( in_filename, argv[1] );
  strcpy( out_filename, argv[1] );
  strupr( in_filename );
  strupr( out_filename );
  strcat( in_filename,  ".ICO" );
  strcat( out_filename, ".WIN" );

  f  = _open( in_filename,  O_RDONLY );
  if( f == CANCEL ){
    cputs( in_filename ); cputs( " file Not Found !!" );
    exit( 1 );
   }
  _read( f, &head_1, sizeof(head_1) );
  if( head_1.size_x != 16 || head_1.size_y != 16 ){
    cputs( in_filename ); cputs( " is Not 16x16 Icon file !!" );
    exit( 2 );
   }
  _close( f );

  load_icon( in_filename, &icon, 0, 9 );

  f = _creat( out_filename, FA_ARCH );
  cputs( in_filename ); cputs( " ==> " ); cputs( out_filename );

  _write( f, &head_2, sizeof( head_2 ) );
  for( i = 0; i < 9; i ++ )
    _write( f, &icon.icon[i][4], 16*16 );

  _close( f );
}

