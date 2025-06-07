#include <game13h.h>

void main()
{
  char *prompt, *command;

  init_midi();
  play_midi( "E.MDI" );

  prompt = getenv( "PROMPT" );
  command = getenv( "COMSPEC" );
  putenv( "PROMPT=Type 'EXIT' to end music.$_$P$G" );

  printf("Type 'EXIT' to end music.\n");
  system( command );
  putenv( prompt );

  stop_music();
  close_midi();
}
