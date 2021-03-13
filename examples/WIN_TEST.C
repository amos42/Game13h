#include <game13h.h>


main()
{
  window_data window;

  init_game13h();

  load_picture( "text.gpg", 0 );
  load_user_window( "win.win" );

  get_key();
  center_window( 5*16, 5*16, &window );
  get_key();
  close_window( &window );

  get_key();
  center_user_window( 5, 5, &window );
  get_key();
  close_window( &window );

  get_key();
  close_game13h();
}
