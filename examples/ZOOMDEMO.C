#include <game13h.h>

void put_zoom_image( image_data image, int x, int y )
{
  image_data image_t;

  image_zoom( image, &image_t, x, y );

  bar( 10, 10, 10+x, 10+y, BLACK );
  copy_put( 10, 10, image_t );

  farfree( image_t );
}

main()
{
  int ch, x = 100, y = 100;
  image_data image;

  init_game13h();
  load_image( "hose.img", &image, 0 );

  put_zoom_image( image, x, y );

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

    put_zoom_image( image, x, y );
  } while( ch != ESC );

  farfree( image );
  close_game13h();
}

