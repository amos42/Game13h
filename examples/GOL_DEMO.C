#include <game13h.h>

main()
{
  palette_data a1[256], a2[256];

  init_game13h();

  set_monitor( OFF );
    load_overlab( "METAL.GOL", 0, a1, a2 );
    change_palette( a1 );
  set_monitor( ON );

  get_key();
  fade_change( a1, a2, 32, 25 );
  get_key();
  fade_change( a2, a1, 32, 25 );
  get_key();

  close_game13h();
}
