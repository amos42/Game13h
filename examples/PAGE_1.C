#include <game13h.h>  /* Ver 4.1 */

main()
{
  int page = 0;

  init_game13h();
  init_page( 2 );

  _page_number = 1;
  load_picture( "PAGE.GPG", 0 );
  _page_number = 2;
  load_picture( "PAGE.GPG", 1 );

  do
    activity_page( page++ % 2 + 1 );
   while( get_key() != ESC );

  close_page();
  close_game13h();
}
