/*******************************************

            WIN ÑÁ·©·i ¥¡µaº…”a.

********************************************/
#include <game13h.h>


main( int argc, char *argv[] )
{
  int x, y;
  int ch, number = 3;

  if( argc < 2 ){
    puts( "Usege : VIEWWIN <Window_file>" );
    exit( 1 );
   }

  init_game13h();
  load_user_window( argv[1] );

  do{
    x = (320 - number*16) / 2;
    y = (200 - number*16) / 2;
    draw_user_window( x, y, number, number );

    ch = get_key();
    bar( x, y, x + number*16, y + number*16, BLACK );
    switch( ch ){
      case UP   : number ++; break;
      case DOWN : number --; break;
     }
    if( number > 12 ) number = 12;
    if( number < 3 ) number = 3;

  } while( ch != ESC );

  close_game13h();
}
