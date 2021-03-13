/*******************************************

            PAL ÑÁ·©·i ¥¡µaº…”a.

********************************************/
#include <game13h.h>


#define SIZE_X 18
#define SIZE_Y 10

main( int argc, char *argv[] )
{
  int i, j, color = 0;

  if( argc < 2 ){
    puts( "Usege : VIEWPAL <Palette_file>" );
    exit( 1 );
   }
  init_game13h();

  for( i = 0; i < 16; i ++ )
    for( j = 0; j < 16; j ++, color ++ )
      bar( i*(SIZE_X+2), j*(SIZE_Y+2), i*(SIZE_X+2)+SIZE_X-1, j*(SIZE_Y+2)+SIZE_Y-1, color );

  i = 0;
  while( !load_palette( argv[1], i ) && get_key() != ESC ) i ++;

  close_game13h();
}
