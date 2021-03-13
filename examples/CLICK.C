#include <game13h.h>


button_data button;


void click_button()
{
  if( check_mouse( 60, 60, 100, 100 ) ){
    mouse_cursor_off();
    push_button( &button );
    mouse_cursor_on();
    delay_program( 200 );
    mouse_cursor_off();
    release_button( &button );
    mouse_cursor_on();
  }
}


main()
{
  init_game13h();
  clear_screen( BLUE );

  init_mouse();
  _user_handle[ LEFT_CLICK ] = click_button;

  make_str_double( 120, 80, "Button •A¡¡·³“¡”a~", YELLOW, 2 );
  box( 59, 59, 101, 101, BLACK );
  draw_button( 60, 60, 100, 100, &button );

  mouse_cursor_on();
  while( !_mouse.double_click );

  close_mouse();
  close_game13h();
}
