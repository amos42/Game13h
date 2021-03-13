/*******************************************

            IMG ÑÁ·©·i ¥¡µaº…”a.

********************************************/
#include <game13h.h>


main( int argc, char *argv[] )
{
  int i = 0, ch = 0;
  image_data data;
  int start_x, start_y;

  if( argc < 2 ){
    puts( "Usege : VIEWIMG <Image_file>" );
    exit( 1 );
   }

  init_game13h();

  while( !load_image( argv[1], &data, i++ ) && ch != ESC ){
    clear_screen( BLACK );
    start_x = (320 - *( (int *)data     )) / 2;
    start_y = (200 - *( (int *)data + 1 )) / 2;
    copy_put( start_x, start_y, data );
    farfree( data );
    ch = get_key();
   }

  close_game13h();
}
