/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/*******************************
  —¡¯aÇaµA¬á Í¥ËaŸi ·ª´á—i·¥”a.
********************************/
int load_font( int han_font, int eng_font, char *path )
{
  int f;
  char file_name[80];
  char *han_font_file[3] = { "HAN_G16.FNT", "HAN_M16.FNT", "HAN_P16.FNT" };
  char *eng_font_file[4] = { "ENG_G16.FNT", "ENG_M16.FNT", "ENG_I16.FNT",
                             "ENG_O16.FNT" };

  /* Ðe‹i Í¥ËaŸi ·ª´á —i·¥”a. */
  if( han_font ){
    strcpy( file_name, path );
    strcat( file_name, han_font_file[ han_font - 1 ] );

    if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 1 );
      _read( f, _hangul1, 6*19*32 );
      _read( f, _hangul2, 2*21*32 );
      _read( f, _hangul3,   28*32 );
    _close(f);
   }

  /* µw¢… Í¥ËaŸi ·ª´á —i·¥”a. */
  if( eng_font ){
    strcpy( file_name, path );
    strcat( file_name, eng_font_file[ eng_font - 1 ] );

    if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 2 );
      _read( f, _english, 94*16 );
    _close(f);
   }

  return( 0 );
}


/******************************
  ·A¸á Í¥ËaŸi ­AËaÐe”a.(Ðe‹i)
*******************************/
int load_font_user_han( char *file_name )
{
  int f;

  if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 1 );
    _read( f, _hangul1, 6*19*32 );
    _read( f, _hangul2, 2*21*32 );
    _read( f, _hangul3,   28*32 );
  _close(f);

  return( 0 );
}


/******************************
  ·A¸á Í¥ËaŸi ­AËaÐe”a.(µw¢…)
*******************************/
int load_font_user_eng( char *file_name )
{
  int f;

  if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 1 );
    _read( f, _english, 94*16 );
  _close(f);

  return( 0 );
}

