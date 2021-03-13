/*********************************

	>> LBM2GPG.C <<

	       - º‰w£¥ -

 LBMÑÁ·©·i Game13h· Îaº… ‹aœÏ¢
 Í¡ •·¥ GPGÑÁ·©¡ ¤aŽ…”a.

**********************************/
#include <game13h.h>


struct picture_header file_head = { "Game13h Picture", 1, 1, NULL, };
struct pic_chunk_head chunk = { 0, TRUE, 0 };

int in_file, out_file;
palette_256 pal_info[256];
void *data;


/***********************
  ÌiAËaŸi Í¡Ðq¯¡Ç¥”a.
************************/
void analysis_pal()
{
  int i, y_or_n;

  cputs( "\n\rInclude Palette data (y/N)? " );
  do
    if( (y_or_n = getch()) == ENTER ) y_or_n = 'N';
   while( y_or_n != 'n' && y_or_n != 'N' && y_or_n != 'y' && y_or_n != 'Y' );
  putch( y_or_n ); putch( '\n' ); putch( '\r' );

  if( y_or_n == 'y' || y_or_n == 'Y' ){
    lseek( in_file, 0x30, SEEK_SET );
    _read( in_file, pal_info, 256*3 );
    for( i = 0; i < 256; i ++ ){
      pal_info[i].red   >>= 2;
      pal_info[i].green >>= 2;
      pal_info[i].blue  >>= 2;
     }
    chunk.pal_flag = TRUE;
   }
}


/**********************
  •A·¡ÈáŸi °á ý“e”a.
***********************/
void analysis_data()
{
  int i;
  byte body[5], code, count;
  char *index;
  dword offset = 0x30 + 256*3;

  while( !strstr( body, "BODY" ) ){
    _read( in_file, &code, 1 );
    if( code >= 'A' && code <= 'Z' ){
      for( i = 0; code >= 'A' && code <= 'Z'; i ++ ){
	body[ i ] = code;
	_read( in_file, &code, 1 );
       }
      body[ i ] = '\0';
     }
   }
/*  while( !strstr(body, "BODY") ){
    lseek( in_file, offset++, SEEK_SET );
    _read( in_file, body, 5 );
   } */
  lseek( in_file, 3, SEEK_CUR );
  offset += 3 + (5 - 1);

  chunk.size = filelength( in_file ) - offset;

  if( chunk.size > 64000 ){
    chunk.size = 64000;
    index = data = farmalloc( 64000 );
    while( index < (char *)data + 64000 ){
      _read( in_file, &count, 1 );
      if( count > 0x80 ){
	count = ~count + 2;
	_read( in_file, &code, 1 );
	while( count-- )
	  *index ++ = code;
       } else{
	count ++;
	while( count -- )
	  _read( in_file, index++, 1 );
       }
     }
    chunk.rle_flag = FALSE;
   } else {
    data = farmalloc( chunk.size );
    _read( in_file, data, chunk.size );
   }
}


main( int argc, char *argv[] )
{
  char in_filename[13], out_filename[13];

  if( argc < 2 ){
    cputs("Usage : LBM2GPG <LBM file name>\n\r");
    exit( 1 );
   }

  strcpy( in_filename, argv[1] );
  strcpy( out_filename, argv[1] );
  strupr( in_filename );
  strupr( out_filename );
  strcat( in_filename,  ".LBM" );
  strcat( out_filename, ".GPG" );

  in_file  = _open( in_filename,  O_RDONLY );
  if( in_file == CANCEL ){
    cputs( in_filename ); cputs( " file Not Found !!" );
    exit( 1 );
   }
  out_file = _creat( out_filename, FA_ARCH );

  cputs( in_filename ); cputs( " ==> " ); cputs( out_filename );

  file_head.offset[0] = sizeof( file_head ) + 0;
  analysis_pal();
  analysis_data();

  _write( out_file, &file_head, sizeof( file_head ) );
  _write( out_file, &chunk, sizeof( chunk ) );
  if( chunk.pal_flag ) _write( out_file, pal_info, 256*3 );
  _write( out_file, data, chunk.size );

  farfree( data );
  _close( in_file );
  _close( out_file );
}
