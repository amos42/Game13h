/***********************************
     ���a 13h ��w ͥ�a �A����.

                 �A�b�a : ���w��

    File Name : F_EDIT.C

 * ϩ�a�e ����;
 GAME13H.H    -- �a���a�១�� �A��
 GAME13H.LIB  -- �a���a�១ ���A
 F_EDIT.C     -- �A���a ��˥
 F_SELECT.C   -- ͥ�a �I�B�a ��˥
 F_MAIN.C     -- �A�� ��˥
 FEDIT.GPG    -- ���e �A����
 H_GT.FNT     -- �e�i ͥ�a
 E_GT.FNT     -- �w�� ͥ�a
***********************************/
#include <game13h.h>  /*  Ver 4.2  */


#define SIZE_X  24
#define SIZE_Y  24

#define CTRL_S 0x13
#define CTRL_L 0x0C
#define CTRL_N 0x0E
#define INS    0x5200
#define DEL    0x5300


char path[80];
char pic_name[80];
char file_name[12 + 1];               /* �e���i �����w      */
image_data temp[99];
icon_data icon = { 0, 24, 24, temp }; /* ͥ�a�i ��w�i ���i */
char buffer[3][24*24 + 4];            /* ���ᝡ �a�� ���i   */

struct icon_header header = { "Game13h Icon__", 1, 1, 24, 24 };


/***********************
  ���e�i ������ �e�a.
************************/
void init_screen()
{
  char *title[] = { " 24x24 Font Editor",
                    "        Ver 1.0",
                    "",
                    " �e�e�� : ���w��",
                   };

  init_game13h();

  strcpy( pic_name, path );
  strcat( pic_name, "FEDIT.GPG" );
  load_picture( pic_name, 0 );
  make_message( title, 4 );
}


/***********************
  ����i ������ ��ǥ�a.
************************/
void init_buffer()
{
  register int i, j;

  for( i = 0; i < 3; i ++ ){
    buffer[i][0] = buffer[i][2] = 24;
    buffer[i][1] = buffer[i][3] = 0;
    for( j = 4; j < 24*24+4; j ++ )
      buffer[i][j] = _attr_null_color;
   }
}


/************************
  ͥ�a�i ������ �e�a.
*************************/
void init_icon()
{
  register int i, j;
  int *temp;
  int fill_color = (int)_attr_null_color | (int)_attr_null_color << 8;

  for( i = 0; i < icon.number; i ++ ){
    (char *)temp = icon.icon[i] = farmalloc( 24 * 24 + 4 );
    temp[0] = temp[1] = 24;
    for( j = 4/2; j < (24*24+4)/2; j ++ )
      temp[j] = fill_color;
   }
}


/***********************
  �����w�i ���b �h�e�a.
************************/
void input_filename()
{
  window_data window;

  center_window( 8*17+15, 16+15, &window );
  make_str_double( window.x + 8, window.y + 8, "�����w :", YELLOW, 1 );

  do{
    bar( window.x + 8*9+8, window.y + 8, window.x + 8*17+8, window.y + 16+8, LIGHTGRAY );
    input_string( window.x + 8*9+8, window.y + 8, file_name, WHITE, 8 );
   } while( strlen(file_name) <= 0 );

  strcat( file_name, ".ICO" );

  close_window( &window );
}


/*************************
     �����i �e�a.
**************************/
void open_file()
{
  int i, f;
  window_data window;
  char number[3];
  struct icon_header temp;

  if( (f = _open( file_name, O_RDONLY )) != CANCEL ){
    _read( f, &temp, sizeof( temp ) );
    _close( f );
    icon.number = temp.number;
    if( icon.number > 99 ) icon.number = 99;
    load_icon( file_name, &icon, 0, icon.number );
   } else{
    center_window( 8*18+15, 16+15, &window );
    make_str_double( window.x + 8, window.y + 8, "ͥ�a ����(1~99):", YELLOW, 1 );
    input_string( window.x + 8*16+8, window.y + 8, number, WHITE, 2 );
    close_window( &window );
    icon.number = atoi( number );
    if( icon.number > 99 ) icon.number = 99;
    if( icon.number < 1  ) icon.number = 1;
    init_icon();
   }

  bar( 16, 45, 285, 184, LIGHTGRAY );
}


/*****************************
  �����A ͥ�a �A����i �e�a.
******************************/
void write_file()
{
  int i, f;

  f = _creat( file_name, FA_ARCH );

  header.number = icon.number;
  _write( f, &header, sizeof( header ) );

  for( i = 0; i < icon.number; i ++ )
    _write( f, (char *)icon.icon[i] + 4, 24*24 );

  _close( f );
}


/***************************
  �a���a ���i �������e�a.
****************************/
void init_mouse_cursor()
{
  byte mouse_cursor[256 + 4] = { 0x10, 0x00, 0x10, 0x00,
    0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xC8, 0x00, 0xFF, 0xFF, 0xFF, 0x00, 0x00,
    0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xC8, 0x00,
    0xFF, 0x00, 0xD3, 0xC5, 0xC8, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0x00, 0xC8, 0x00, 0xD3, 0xC5, 0xC8, 0xC8, 0xC8, 0x00, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xC8, 0xC5, 0xCF, 0xC8,
    0xC8, 0xC8, 0xC8, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xD3,
    0x00, 0xC8, 0xC5, 0xC8, 0xC8, 0xC8, 0xCF, 0xD8, 0x00, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0x00, 0xD5, 0x00, 0xC8, 0xC8, 0xC8, 0xCF, 0xD8, 0xE3,
    0xE2, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xD3, 0xD0, 0xCF,
    0xCF, 0xD8, 0xE3, 0x40, 0xE3, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0x00, 0x00, 0x00, 0xD8, 0xE5, 0xE3, 0xE3, 0x00, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xE7, 0xE5, 0x00,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF,
   };

  set_mouse_cursor( mouse_cursor );
  mouse_cursor_on();
}


void click_any_key()
{
  put_key( ENTER );
}



main( int argc, char *argv[] )
{
  get_exec_path( path );

  init_screen();
  init_buffer();
  init_mouse();

  if( argc < 2 )
    input_filename();
   else{
    strcpy( file_name, argv[1] );
    if( strstr( file_name, "." ) == NULL )
      strcat( file_name, ".ICO" );
   }

  open_file();
  init_mouse_cursor();
  select_icon_data();

  close_mouse();
  free_icon( &icon );
  close_game13h();
}
