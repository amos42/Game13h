#include <game13h.h>

main()
{
  int i, k;
  image_data image[3];
  int char_table[4] = { 0, 1, 2, 1 };

  init_game13h();
  init_page( 1 );

  _page_number = 1;
  load_picture( "TEXT.GPG", 0 );
  activity_page( 1 );
  set_clip_window( 17, 41, 300, 164 );

  for( i = 0; i < 3; i ++ )
    load_image( "CAVE.IMG", &image[i], i );

  for( i = -15, k = 0; i < 320; i += 5, k++ ){
    copy_page_cut( 1, 0, i-5, 100, i + 50, 115 );
    char_put_clip_x( i, 100, image[ char_table[k % 4] ] );

    if( action_key() == ESC ) break;
    delay_program( 200 );
   }

  for( i = 0; i < 3; i ++ )
    farfree( image[i] );

  close_page();
  close_game13h();
}
