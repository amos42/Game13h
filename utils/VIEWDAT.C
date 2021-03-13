/****************************************

        DAT ‹aŸ±·i ÑÁ¡eµA ¥¡µaº…”a.

*****************************************/
#include <game13h.h>


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

  if( (f = _open(filename, O_RDONLY)) == NULL ) return( 1 );
  file_size = filelength( f );
  data = farmalloc( file_size );
  _read( f, data, file_size );
  _close( f );

  asm PUSH DS

  asm MOV AX, 0A000h
  asm MOV ES, AX
  asm XOR DI, DI

  asm LDS SI, DWORD PTR data

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


main( int argc, char *argv[] )
{
  if( argc < 2 ){
    puts( "Usege : VIEWDAT Dat_file" );
    exit( 1 );
   }

  init_game13h();

  pic_data_load( argv[1] );
  delay_key();

  close_game13h();
}

