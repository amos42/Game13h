#include <game13h.h>  /* Ver 4.2 */

void main()
{
  register int i;
  int x = 100, y = 80, step, handle;
  int joy_x, joy_y, button = 0;
  image_data image;
  int noise_flag = FALSE;

  init_game13h();
  xms_install();
  init_midi();
  set_clip_window( 17, 41, 300, 164 );
  init_page( 1 );

  play_midi( "E.MDI" );
  set_monitor( OFF );
    load_picture( "TEXT.GPG", 0 );
    make_str_multi( 0, 0, "Key Pressed : ", 8*16 );
    handle = store_screen( 0 );
    load_image( "HOSE.IMG", &image, 0 );
    char_put( x, y, image );
    fix_palette();
    all_palette( BLACK );
  set_monitor( ON );

  fade_in( BLACK, 64, 25 );
  set_cycle( 175, 128, NO_DELAY );
  _page_number = 1;
  _attr_shadow_color = 3;

  while( button != 3 ){
    if( noise_flag ){
      tv_noise_clip();
      bar( 120, 0, 120+7+2, 15+2, BLACK );
     } else
      restore_screen( handle, 1 );

    get_joy_stick( &joy_x, &joy_y );
    button = get_joy_button();

    char_put_clip( x, y, image );
    make_str_double( 120, 0, str( button ), WHITE, 2 );
    copy_page( 1, 0 );

    if( button == 1 ) step = 1; else step = 10;
    if( joy_y < 200 ) y -= step;               /* Up    */
    if( joy_y > 800 ) y += step;               /* Down  */
    if( joy_x < 100 ) x -= step;               /* Left  */
    if( joy_x > 800 ) x += step;               /* Right */

    if( button == 2 ) noise_flag = TRUE; else noise_flag = FALSE;
   }
  stop_music();

  _change_palette_flag = FALSE;
  for( i = 0; i < 64; i ++ ){
    fade_out_step( BLACK, i );
    delay_program( 25 );
   }
  reset_cycle();

  farfree( image );
  xms_free( handle );

  close_page();
  close_midi();
  close_game13h();
}
