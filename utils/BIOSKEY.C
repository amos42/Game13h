#include <game13h.h>

#define ESC   0x011B


int bios_key( void )
{
  _AH = 0
  __int__( 0x16 );
}

main()
{
  int ch;

  do{
    ch = bios_key();
    printf( "0x%04X  ", ch );
   }while( ch != ESC );
}
