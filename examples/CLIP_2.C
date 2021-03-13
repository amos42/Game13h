#include <game13h.h>  /* Ver 4.2 */

main()
{
  int x = 100, y = 80, step, handle;
  void *image;
  int noise_flag = FALSE;

  init_game13h();
  xms_install();
  init_midi();
  set_clip_window( 17, 41, 300, 164 );
  init_page( 1 );

  play_midi( "E.MDI" );
  set_monitor( OFF );
    load_picture( "TEXT.GPG", 0 );
    make_str_multi( 0, 0, "Key Pressed : ", 8*16, NO_DELAY );
    handle = store_screen( 0 );
    load_image( "HOSE.IMG", &image, 0 );
    char_put( x, y, image );
    fix_palette();
    all_palette( BLACK );
  set_monitor( ON );

  fade_in( BLACK, 64, 25 );
  set_cycle( 175, 128, NO_DELAY );
  set_multi_key();
  _page_number = 1;
  _attr_shade_color = 3;

  while( !( _key.scan[29] && _key.scan[56] && _key.scan[83] ) ){  /* Ctrl+Alt+Del */
    if( noise_flag ){
      tv_noise_clip();
      bar( 120, 0, 120+7+2, 15+2, BLACK );
     } else
      restore_screen( handle, 1 );

    char_put_clip( x, y, image );
    make_str_double( 120, 0, str( _key.press ), WHITE, NO_DELAY, 2 );
    copy_page( 1, 0 );

    if( _key.scan[56] ) step = 1; else step = 10;  /* Alt */
    if( _key.scan[72] ) y -= step;                 /* Up    */
    if( _key.scan[80] ) y += step;                 /* Down  */
    if( _key.scan[75] ) x -= step;                 /* Left  */
    if( _key.scan[77] ) x += step;                 /* Right */

    noise_flag = _key.scan[1];                     /* ESC   */
   }
  reset_multi_key();
  stop_melody();

  _change_palette_flag = FALSE;
  fade_out( BLACK, 32, 25 );

  reset_cycle();

  farfree( image );
  xms_free( handle );

  close_page();
  close_midi();
  close_game13h();
}
