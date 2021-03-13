#include <game13h.h>


image_data data;
char file_name[13];


int find_bound_top()
{
  int i, j;

  for( i = 0; i < 200; i ++ )
    for( j = 0; j < 320; j ++ )
      if( get_pixel( j, i ) != _attr_null_color ) return( i );

  return( 0 );
}

int find_bound_bottom()
{
  int i, j;

  for( i = 199; i >= 0; i -- )
    for( j = 0; j < 320; j ++ )
      if( get_pixel( j, i ) != _attr_null_color ) return( i );

  return( 0 );
}

int find_bound_left()
{
  int i, j;

  for( i = 0; i < 320; i ++ )
    for( j = 0; j < 200; j ++ )
      if( get_pixel( i, j ) != _attr_null_color ) return( i );

  return( 0 );
}

int find_bound_right()
{
  int i, j;

  for( i = 319; i >= 0; i -- )
    for( j = 0; j < 200; j ++ )
      if( get_pixel( i, j ) != _attr_null_color ) return( i );

  return( 0 );
}


void save_img()
{
  int i, f;
  struct image_header header = { "Game13h Image__", 1, 1, sizeof(header), };

  f =_creat( file_name, FA_ARCH );
  _write( f, &header, sizeof( header ) );
  _write( f, data, image_size( data ) );

  _close( f );
}


main( int argc, char *argv[] )
{
  int s_x, s_y, e_x, e_y;

  if( argc < 2 ){
    puts("Usege : CUT_IMG <GPG_name> [Null_Color]");
    exit(1);
   }

  if( argc < 3 )
    _attr_null_color = NULL_COLOR;
   else
    _attr_null_color = (byte)atoi( argv[2] );

  init_page( 1 );
  _page_number = 1;

  strcpy( file_name, argv[1] );
  strcat( file_name, ".GPG" );
  load_picture( file_name, 0 );

  strcpy( file_name, argv[1] );
  strcat( file_name, ".IMG" );

  s_y = find_bound_top();
  e_y = find_bound_bottom();
  s_x = find_bound_left();
  e_x = find_bound_right();
  if( !s_x || !s_y || !e_x || !e_y ){
    puts( "\aError get image !" );
    exit(1);
   }

  get_image( s_x, s_y, e_x, e_y, &data );
  save_img();
  farfree( data );

  close_page();
}

