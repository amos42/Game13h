#include <game13h.h>


main()
{
  int ch;

  do{
      ch = get_key();
      printf( "0x%04X  ", ch );
    }while( ch != ESC );
}
