#include <game13h.h>

main()
{
  int x1, y1, x2, y2;
  byte color;

  init_game13h();
  load_font( H_NULL, E_OB, "" );
  box( 0, 0, MAX_X, MAX_Y, LIGHTBLUE );
  randomize();

  while( !action_key() ){
    x1 = random(320);
    y1 = random(200);
    x2 = random(320);
    y2 = random(200);
    color = random(256);
    bar( 0, 0, 120, 16, BLACK );
    make_str_multi( 0,  0, str(x1), WHITE );
    make_str_multi( 24, 0, ",", WHITE );
    make_str_multi( 32, 0, str(y1), WHITE );
    make_str_multi( 56, 0, "~", WHITE );
    make_str_multi( 64, 0, str(x2), WHITE );
    make_str_multi( 88, 0, ",", WHITE );
    make_str_multi( 96, 0, str(y2), WHITE );

    line( x1, y1, x2, y2, color );
   }

  get_key();
  close_game13h();
}
