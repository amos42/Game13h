#include <game13h.h>

main()
{
  int ch, x = 1, y = 1;
  image_data image, image_t;

  init_game13h();
  load_image( "hose.img", &image, 0 );

  do{
    ch = get_key();

    switch( ch ){
      case LEFT   : x --; break;
      case RIGHT  : x ++; break;
      case UP     : y --; break;
      case DOWN   : y ++; break;
    }
    if( x < 1 ) x = 1;
    if( y < 1 ) y = 1;

    image_zoom( image, &image_t, x, y );
    bar( 10, 10, 10+x, 10+y, BLACK );
    copy_put( 10, 10, image_t );
    farfree( image_t );
  } while( ch != ESC );

  farfree( image );
  close_game13h();
}

