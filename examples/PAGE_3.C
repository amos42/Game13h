#include <game13h.h>  /* Ver 4.2 */

main()
{
  int page = 0;
  int handle[2];

  if( xms_install() ){
    puts( "Not install XMS Driver!" );
    exit( 1 );
   }
  init_game13h();

  set_monitor( OFF );
    load_picture( "PAGE.GPG", 1 );
    handle[1] = store_screen( 0 );
    load_picture( "PAGE.GPG", 0 );
    handle[0] = store_screen( 0 );
  set_monitor( ON );

  do
    restore_screen( handle[page++ % 2], 0 );
   while( get_key() != ESC );

  xms_free( handle[0] );
  xms_free( handle[1] );

  close_game13h();
}
