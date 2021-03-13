/*******************************************

            GOL ÑÁ·©·i ¥¡µaº…”a.

********************************************/
#include <game13h.h>


main( int argc, char *argv[] )
{
  int flag = FALSE;
  palette_data pal[2][256];

  if( argc < 2 ){
    puts( "Usege : VIEWGOL <OverLab_file>" );
    exit( 1 );
   }

  init_game13h();

  all_palette( BLACK );
  load_overlab( argv[1], 0, pal[0], pal[1] );
  change_palette( pal[0] );

  while( get_key() != ESC ){
    fade_change( pal[flag], pal[!flag], 32, 50 );
    flag = !flag;
   } 

  close_game13h();
}

