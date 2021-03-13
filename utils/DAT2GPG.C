/*********************************

       >> DAT2GPG.C <<

                    - º‰w£¥ -

 4.0· DATÑÁ·©·i Game13h 4.1·
 Í¡ •·¥ GPGÑÁ·©¡ ¤aŽ…”a.

**********************************/
#pragma inline
#include <game13h.h>
#include <dir.h>


struct picture_header file_head = { "Game13h Picture", 1, 1, NULL, };
struct pic_chunk_head chunk = { 0, TRUE, FALSE };

int out_file;
char *data;


/***************************************
  ‹aŸ± •A·¡ÈáŸi —¡¯aÇaµA¬á ·ª´á—i·¥”a.
  ”e, •A·¡Èá“e PCXÑw·¡¡a, ÑA”áµÁ ÌiAËa
  ¸÷¥¡“e ¹Aˆá–A´á ·¶´á´¡ Ðe”a.
****************************************/
char pic_data_load( char *filename )
{
  int f;
  word file_size;
  char *data;

  if( (f = _open(filename, O_RDONLY)) == CANCEL ) return( 1 );
  file_size = filelength( f );
  if( (data = farmalloc( file_size )) == NULL ) return( 2 );
  _read( f, data, file_size );
  _close( f );

  asm PUSH DS

  asm LDS SI, DWORD PTR data

  asm MOV AX, 0A000h
  asm MOV ES, AX
  asm XOR DI, DI

  asm CLD

 LC_LOOP:
  asm LODSB
  asm MOV BL, AL
  asm AND BL, 11000000b
  asm CMP BL, 11000000b
  asm JE RLE

  asm STOSB
  asm JMP NEXT

 RLE:
  asm AND AL, 00111111b
  asm XOR CH, CH
  asm MOV CL, AL
  asm LODSB
  asm REP STOSB

 NEXT:
  asm CMP DI, 64000d
  asm JB LC_LOOP

  asm POP DS

  farfree( data );
  return( 0 );
}


/**********************
  •A·¡ÈáŸi °á ý“e”a.
***********************/
void analysis_data()
{
  chunk.pal_flag = FALSE;
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
  struct ffblk ff;

  if( argc < 2 ){
    cputs("Usage : DAT2GPG <DAT file name>\n\r");
    exit( 0 );
   }

  strcpy( in_filename, argv[1] );
  strcpy( out_filename, argv[1] );
  strupr( in_filename );
  strupr( out_filename );
  strcat( in_filename,  ".DAT" );
  strcat( out_filename, ".GPG" );

  if( findfirst( in_filename, &ff, FA_RDONLY ) ){
    cputs( in_filename ); cputs( " file Not Found !!" );
    exit( 2 );
   }

  cputs( in_filename ); cputs( " ==> " ); cputs( out_filename );

  init_page( 1 );
  out_file = _creat( out_filename, FA_ARCH );

  _page_number = 1;
  pic_data_load( in_filename );
  file_head.offset[0] = sizeof( file_head ) + 0;
  analysis_data();

  _write( out_file, &file_head, sizeof( file_head ) );
  _write( out_file, &chunk, sizeof( chunk ) );
  _write( out_file, data, chunk.size );

  farfree( data );
  _close( out_file );

  close_page();
}
