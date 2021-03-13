#include <game13h.h>


void display_mouse_position()
{
  mouse_cursor_off();
  bar( 0, 0, 73, 15, LIGHTBLUE );
  make_str_double(  0, 0, str(_mouse.x), WHITE, 2 );
  make_str_double( 32, 0, ",", WHITE, 2 );
  make_str_double( 48, 0, str(_mouse.y), WHITE, 2 );
  mouse_cursor_on();
}


main()
{
  int i, ch;
  voice_data signal;
  icon_data icon;

  init_game13h();
  load_voice( "COIN.VOC", &signal );

/*  init_voice( S_BLASTER );*/
  init_voice( PC_SPEAKER );

  init_mouse();

  clear_screen( LIGHTBLUE );
  make_str_multi( 30, 40, "´e‘wÐa­A¶a. Demo ·³“¡”a.", 6*16 );
  load_icon( "ITEM.ICO", &icon, 1, 0 );
  mouse_cursor_on();
  _user_handle[ MOUSE_MOVE ] = display_mouse_position;

  for( i = 0; i < icon.number; i ++ ){
    while( !_mouse.double_click ){
      ch = action_key();
      if( ch == ESC ) break;
     }
    set_mouse_cursor( icon.icon[i] );
    output_voice( signal );
    if( _mouse.right || ch == ESC ) break;
    delay_program( 150 );
   }

  close_mouse();
  while( _voice_flag );

  free_voice( &signal );
  free_icon( &icon );
  close_voice();
  close_game13h();
}
