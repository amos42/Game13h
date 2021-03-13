/*****************************************
     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"


/************************************
  ¬åÈ‚–E ¶áÃ¡µA ¬aˆbÑw Äá¬áŸi Îa¯¡.
*************************************/
#define index_cursor( x, y, color ) box( (x)-1, (y)-1, (x)+16, (y)+16, (color) )


/**************************************
  —¡¯aÇaµA¬á ´a·¡Å¥ ÑÁ·©·i ·ª´á—i·¥”a.
***************************************/
int load_icon( char *file_name, icon_data *icon, word start, word icon_number )
{
  int i, f;
  char **array; int *temp;
  word icon_size;
  struct icon_header header;

  if( (f = _open( file_name, O_RDONLY )) == CANCEL ) return( 1 );

  _read( f, &header, sizeof( header ) );
  if( strcmp( header.head_id, "Game13h Icon___" ) ){
    _close( f );
    return( 2 );
   }
  if( icon_number + start > header.number ){
    _close( f );
    return( 3 );
   }

  if( !icon_number ) icon_number = header.number - start;

  array = farmalloc( icon_number << 2 );
  icon->number = icon_number;
  icon->size_x = header.size_x;
  icon->size_y = header.size_y;
  icon->icon = array;

  icon_size = header.size_x * header.size_y;
  lseek( f, start*icon_size, SEEK_CUR );

  for( i = 0; i < icon_number; i ++ ){
    (char *)temp = *array++ = farmalloc( icon_size + 4 );
    temp[0] = header.size_x;
    temp[1] = header.size_y;
    _read( f, &temp[2], icon_size );
   }

  _close( f );

  return( 0 );
}


/**********************************
  ´a·¡Å¥ ¤µi· ¡A¡¡Ÿ¡Ÿi Ð¹AÐe”a.
***********************************/
void free_icon( icon_data *icon )
{
  int i;
  int icon_number = icon->number;
  char **array = icon->icon;

  for( i = 0; i < icon_number; i ++ )
    farfree( array[i] );

  farfree( array );
}


static void disp_icon( int x, int y, image_data *icon, int start, int number )
{
  register int i;

  bar( x, y, x + number*20 - 20 + 15, y + 15, LIGHTGRAY );

  for( i = 0; i < number; i ++ )
    char_put( x + i*20, y, icon[start + i] );
}

/********************
  ´a·¡ÉQ·i ‰¡Ÿe”a.
*********************/
int select_icon( icon_data icon, word disp )
{
  register int i;
  window_data window;
  int index = 0, s_index = 0;
  int x, y;
  int ch;

  if( disp > 14 ) return( CANCEL );
  if( disp > icon.number ) disp = icon.number;
  center_window( 20*disp + 16-4, 16+8*2, &window );
  x = window.x + 8;
  y = window.y + 8;

  disp_icon( x, y, icon.icon, 0, disp );
  index_cursor( x, y, LIGHTBLUE );
  icon.number --;

  do{
    ch = get_key();

    index_cursor( x + s_index*20, y, LIGHTGRAY );

    switch( ch ){
      case HOME  : index -= s_index; s_index = 0;
                   break;
      case END   : index += (disp - 1 - s_index); s_index = disp - 1;
                   break;
      case LEFT  : if( index > 0 ){
                     index --; s_index --;
                     if( s_index < 0 ){
                       s_index = 0;
                       disp_icon( x, y, icon.icon, index, disp );
                      }
                    }
                   break;
      case RIGHT : if( index < icon.number ){
                     index ++; s_index ++;
                     if( s_index >= disp ){
                       s_index = disp - 1;
                       disp_icon( x, y, icon.icon, index - s_index, disp );
                      }
                    }
                   break;
     }

    index_cursor( x + s_index*20, y, LIGHTBLUE );

   } while( ch != ENTER && ch != SPACE && ch != ESC );

  close_window( &window );

  if( ch == ESC )
    return( CANCEL );
   else
    return( index );
}

