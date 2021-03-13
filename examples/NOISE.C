#include <game13h.h>

main()
{
  init_game13h();
  init_midi();

  play_midi( "NOISE.MDI" );

  while( !action_key() )
    tv_noise();

  stop_music();
  close_midi();
  close_game13h();
}
