/*********************************

	>> LBM2GPG.C <<

	       - º‰w£¥ -

 LBMÑÁ·©·i Game13h· Îaº… ÌiœËa
 Í¡ •·¥ PALÑÁ·©¡ ¤aŽ…”a.

**********************************/
#include <game13h.h>


struct palette_header file_head = { "Game13h Palette", 1, 1 };

main( int argc, char *argv[] )
{
  register int i;
  int in_file, out_file;
  char in_filename[13], out_filename[13];
  unsigned char data[768];

  if( argc < 2 ){
    printf("Usage : LBM2PAL <LBM file name>\n");
    exit( 1 );
   }

  strcpy( in_filename, argv[1] );
  strcpy( out_filename, argv[1] );
  strupr( in_filename );
  strupr( out_filename );
  strcat( in_filename,  ".LBM" );
  strcat( out_filename, ".PAL" );

  in_file  = _open( in_filename,  O_RDONLY );
  if( in_file == CANCEL ){
    cputs( in_filename ); cputs( " file Not Found !!" );
    exit( 1 );
   }
  out_file = _creat( out_filename, FA_ARCH );

  printf("%s ==> %s ...", in_filename, out_filename );

  lseek( in_file, 0x30, SEEK_SET );
  _read( in_file, data, 768 );

  for( i = 0; i < 768; i ++ )
    data[i] >>= 2;

  _write( out_file, &file_head, sizeof( file_head ) );
  _write( out_file, data, 768 );

  _close( in_file );
  _close( out_file );
}
