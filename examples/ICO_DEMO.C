#include <game13h.h>


main()
{
  int select;
  icon_data icon;

  init_game13h();
  clear_screen( BLUE );
  load_icon( "ITEM.ICO", &icon, 1, NULL );

  select = select_icon( icon, 10 );

  make_str_double( 50,  100, "¬åÈ‚–E ´a·¡Å¥ ¤åÑ¡:", WHITE, 2 );
  make_str_double( 210, 100, str(select), YELLOW, 2 );
  get_key();

  free_icon( &icon );
  close_game13h();
}
