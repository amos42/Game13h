/*******************************************

	    GPG ÑÁ·©·i ¥¡µaº…”a.

********************************************/
#include <game13h.h>


main( int argc, char *argv[] )
{
  int i = 0;

  if( argc < 2 ){
    puts( "Usege : VIEWGPG <Game_Picture_Group>" );
    exit( 1 );
   }

  init_game13h();

  while( !load_picture( argv[1], i ) && get_key() != ESC ) i ++;

  close_game13h();
}
