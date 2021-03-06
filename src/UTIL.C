/*****************************************

     ���a 13h�w �A�� �b�� �a���a�១
                       Ver 4.2

                 �A�b�a:
                        �� �w ��

  �A�� �b���i ��Ё �e�e �a���a�១����
 ���a 13h (320x200, 256) ��w���a.

*****************************************/
#include "game13h.h"


static char str_temp[5+1];


/************************
    Yes, No�i �e�e.
*************************/
bool yes_or_no( void )
{
  window_data window;
  bool index = TRUE;
  int ch;
  int box_sqr[2] = { 182, 88 };

  if( _use_mouse ) mouse_cursor_off();
    open_window( 80, 84, 240, 115, &window );
    make_str_double( 80 + 7, 84 + 8, "  �A        �a���a", YELLOW, 1 );
    box( box_sqr[index], 91, box_sqr[index] + 50, 108, LIGHTBLUE );
  if( _use_mouse ) mouse_cursor_on();

  do{
    ch = get_key();
    if( _use_mouse ) mouse_cursor_off();
    box( box_sqr[index], 91, box_sqr[index] + 50, 108, LIGHTGRAY );

    switch( ch ){
      case LEFT  : index = TRUE;     break;
      case RIGHT : index = FALSE;    break;
     }

    box( box_sqr[index], 91, box_sqr[index] + 50, 108, LIGHTBLUE );
    if( _use_mouse ) mouse_cursor_on();
   } while( ch != ENTER && ch != SPACE );

  if( _use_mouse ) mouse_cursor_off();
    close_window( &window );
  if( _use_mouse ) mouse_cursor_on();
  return( index );
}


/***********************************
    �a���a���� ���a�i �·��e�a.
************************************/
bool reply_quit( void )
{
  int box_sqr[2] = { 183, 88 };
  bool index = FALSE;
  int ch;
  window_data window;

  if( _use_mouse ) mouse_cursor_off();
    open_window( 64, 72, 256, 127, &window );
    make_str_double( 64 + 8, 72 + 8,  "���i ���a�a���V�s���a?", WHITE, 1 );
    make_str_double( 64 + 8, 72 + 30, "    �A        �a���a", YELLOW, 1 );

    box( box_sqr[index], 101, box_sqr[index] + 50, 119, LIGHTBLUE );
  if( _use_mouse ) mouse_cursor_on();

  do{
    ch = get_key();
    if( _use_mouse ) mouse_cursor_off();
    box( box_sqr[index], 101, box_sqr[index] + 50, 119, LIGHTGRAY );

    switch( ch ){
      case LEFT  : index = TRUE;		break;
      case RIGHT : index = FALSE;	break;
     }

    box( box_sqr[index], 101, box_sqr[index] + 50, 119, LIGHTBLUE );
    if( _use_mouse ) mouse_cursor_on();
   } while( ch != ENTER );

  if( _use_mouse ) mouse_cursor_off();
    close_window( &window );
  if( _use_mouse ) mouse_cursor_on();
  return( index );
}


/*********************************
  Ή ́�a�w�A�� ́�a�e�i ��e�a.
**********************************/
void get_exec_path( char *path )
{
  int i = 0;
  int check;

  strcpy( path, _argv[0] );

  while( path[i] != '\0' ){
    if( path[i] == '\\' ) check = i;
    i ++;
   }

  path[ check+1 ] = '\0';
}


/*****************************
  ���a�i ���a�� �a���� ���a.
******************************/
char *str( int number )
{
  itoa( number, str_temp, 10 );
  return( str_temp );
}


/**********************************
  ���a�i ���a�� �a���� ���a.(Hex)
***********************************/
char *str_hex( int number )
{
  itoa( number, str_temp, 16 );
  return( str_temp );
}

