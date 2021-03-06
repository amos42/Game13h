/*********************************

       >> PCX2GPG.C <<

                    - ���w�� -

 PCX�����i Game13h�� �a�� �a��Ϣ
 ͡���� GPG������ �a���a.

**********************************/
#include <game13h.h>


struct picture_header file_head = { "Game13h Picture", 1, 1, NULL, };
struct pic_chunk_head chunk = { 0, TRUE, FALSE };

int in_file, out_file;
palette_data pal_info[256];
char *data;


/*******************************
  �a�w �A�����A PCX�i �刁�e�a.
********************************/
void load_pcx_file()
{
  char count, indata;
  char *video = page_pointer( 1 );
  char *end_ptr = (char *)(video + 0xFA00);

  lseek( in_file, 0x80, SEEK_SET );

  do{
    _read( in_file, &indata, 1 );
    if( (indata & 0xC0 ) == 0xC0 ){
      count = indata & 0x3F;
      _read( in_file, &indata, 1 );
      while( count-- )
        *video++ = indata;
     } else
      *video++ = indata;
   } while( video < end_ptr );
}


/***********************
  �i�A�a�i ͡�q��ǥ�a.
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
    lseek( in_file, -768, SEEK_END );
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
  �A����i �� ���e�a.
***********************/
void analysis_data()
{
  chunk.size = incode_picture( &data, 1 );
  if( !chunk.size ){
    chunk.rle_flag = FALSE;
    chunk.size = 64000;
    farfree( data );
    data = page_pointer( 1 );
   } else
    chunk.rle_flag = TRUE;
}


main( int argc, char *argv[] )
{
  char in_filename[13], out_filename[13];

  if( argc < 2 ){
    cputs("Usage : PCX2GPG <PCX file name>\n\r");
    exit( 0 );
   }

  strcpy( in_filename, argv[1] );
  strcpy( out_filename, argv[1] );
  strupr( in_filename );
  strupr( out_filename );
  strcat( in_filename,  ".PCX" );
  strcat( out_filename, ".GPG" );

  in_file  = _open( in_filename,  O_RDONLY );
  if( in_file == CANCEL ){
    cputs( in_filename ); cputs( " file Not Found !!" );
    exit( 1 );
   }
  out_file = _creat( out_filename, FA_ARCH );

  cputs( in_filename ); cputs( " ==> " ); cputs( out_filename );

  init_page( 1 );

  file_head.offset[0] = sizeof( file_head ) + 0;
  load_pcx_file();
  analysis_data();

  _write( out_file, &file_head, sizeof( file_head ) );
  _write( out_file, &chunk, sizeof( chunk ) );
  if( chunk.pal_flag ) _write( out_file, pal_info, 256*3 );
  _write( out_file, data, chunk.size );

  farfree( data );
  _close( in_file );
  _close( out_file );

  close_page();
}
