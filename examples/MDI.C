#include <game13h.h>

main()
{
  char *prompt;

  init_midi();
  play_midi( "E.MDI" );

  prompt = getenv( "PROMPT" );
  putenv( "PROMPT=Type 'EXIT' to end music.$_$P$G" );
  system( "%COMSPEC" );
  putenv( prompt );

  stop_music();
  close_midi();
}
