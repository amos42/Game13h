/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"

/* Some MIDI codes. */
#define END_OF_TRACK 0x2F
#define TEMPO        0x51
#define NR_CHANS     16
#define SYSEX_F0     0xF0
#define SYSEX_F7     0xF7
#define META         0xFF
#define SEQ_SPECIFIC 0x7F
#define MAX_VOICES   11
#define TRACKS       16

#define  music_ptr (*music_ptr_ptr)

static byte *midi_data;

static int tracks;                   /* number of tracks */
static int tick_quarter_note;        /* ticks per quarter note */
static byte **music_ptr_ptr;         /* ptr into track_ptr */
static byte *status;                 /* ‹¡¹¥ Ëaœ‚· µeº ¬wÈ Í¡·¥Èá */

static long tick_count = 0;          /* current absolute time */
static int  current_track = 0;       /* current track */

static byte *track_ptr[ TRACKS ];        /* ptrs to each data track */
static byte track_stat[ TRACKS ];        /* running status for each track */
static dword abs_time[ TRACKS ];         /* time of next event for each track */
static int current_vol[ MAX_VOICES ];

bool   _playing_flag;               /* ÏiA·¡ º—·¥ˆa? */
static bool end_of_data;            /* •A·¡Èá· {µA •¡”iÐ–“eˆa? */
static bool clock_in = FALSE;       /* ·¥¯aÉ© –A´ö“eˆa? */
static bool volume_flag = TRUE;     /* ¥©ŸQ·i µ©v“eˆa? */
static bool adlib_ok;               /* ´—iŸ³ Äa—aˆa ·¶“eˆa? */


/******************************
  ˆb Ëaœ‚· Í¡·¥ÈáŸi ¬é¸÷Ðe”a.
*******************************/
static void setup_tracks( int tracks, byte *chunk )
{
  int i;
  dword length;

  for( i = 0; i < tracks; i ++ ){
    length = get_dword( chunk + 4 );
    chunk += 8;
    track_ptr[i] = chunk;
    chunk += length;
   }
}


/*****************************************
  MIDIÑÁ·©· •A·¡ÈáµA¬á ‹©·¡Ÿi ©³´a…”a.
******************************************/
static dword get_length()
{
  dword value;
  byte c, *data;

  data = music_ptr;

  if( (value = *data++) & 0x80 ){
    value &= 0x7f;
    do
      value = (value << 7) + ((c = *data++) & 0x7F);
     while( c & 0x80 );
   }

  music_ptr = data;
  return( value );
}


/************************************************
  £¡—¡Ÿi µeºÐa‹¡ ¶áÐ ÑÁ·©· Š¹¡Ÿi ¦…¬âÐe”a.
*************************************************/
static void setup_data()
{
  int i, j;
  byte *data_ptr = midi_data;
  long length;

  for( i = 0; i < MAX_VOICES; i ++ ){
    current_vol[i] = 0;
    set_voice_volume( i, 0 );
    note_off( i );
   }

  tick_count = 0L;                         /* current absolute time */
  current_track = 0;

  /* Read file header */
  length = get_dword( data_ptr + 4 );        /* header length */
  tracks = get_word( data_ptr + 10 );        /* number of tracks */
  tick_quarter_note = get_word( data_ptr + 12 );    /* ticks per quarter note */

  /* Set music_ptr to point to start of first chunk */
  data_ptr += (length + 8L);

  /* Set up the array track_ptr */
  setup_tracks( tracks, data_ptr );

  /* Initialize arrays */
  for( i = 0; i < tracks; i ++ ){
    music_ptr_ptr = &track_ptr[i];        /* set global data ptr */
    abs_time[i] = get_length();           /* set start time for track */
    track_stat[i] = *music_ptr;           /* current running status for track */
   }
}


/********************
  ÉQÍ¡Ÿi ¬é¸÷Ðe”a.
*********************/
static void set_tempo( word tick_quarter_note, long usec )
{
  long count;

  /* ¶aÀ÷ Interrupt ºÌa® ‰¬e (ticks/sec) */
  if( tick_quarter_note )
    count = 1194L * (usec / 1000) / tick_quarter_note;
   else
    count = 0L;

  set_clock_rate( (word)count );  /* Äa¶…Ëa ­AËa */
}


/*************************
  ”a·q· —©A·¡Ÿi Àx“e”a.
**************************/
static word get_next_delay()
{
  int i, min;
  long delta;

  if( *status != END_OF_TRACK ){
    delta = get_length();                       /* get delta time */
    abs_time[current_track] += delta;           /* set new time for track */
   } else
    abs_time[current_track] = 0x7FFFFFFFL;      /* impossibly large value */

  for( min = 0, i = 1; i < tracks; i ++ )
    if( abs_time[i] < abs_time[min] && track_stat[i] != END_OF_TRACK )
      min = i;

  if( track_stat[min] == END_OF_TRACK ){
    end_of_data = TRUE;
    _playing_flag = FALSE;
    return( 0 );
   }

  delta = abs_time[min] - tick_count;  /* calculate time until next event */
  tick_count = abs_time[min];          /* set current time */
  music_ptr_ptr = &track_ptr[min];     /* reset data ptr */
  status = &track_stat[min];           /* set running status */
  current_track = min;

  return( (word)delta );
}


/*******************************************
  ˆb ¥¡·¡¯a· ‘¡Ëa, ¥©ŸQ·i Ðe¤åµA ¬é¸÷Ðe”a.
********************************************/
static void my_note_on( int voice, int note, int volume )
{
  /*  e´¢ ¥©ŸQ·¡ ´ô”a¡e ‘¡ËaŸi µ¡Ïa */
  if( !volume ){
    note_off( voice );
    current_vol[ voice ] = volume;
   } else {
    if( current_vol[ voice ] != volume ){
      set_voice_volume( voice, volume );
      current_vol[ voice ] = volume;
     }
    note_on( voice, note );
   }
}


/*********************************************
  AdLib· Ëb®Ðe ·¡¥EËa ¡yˆŸi ÀáŸ¡Ða“e žË¥.
**********************************************/
static void adlib_specific( int code, byte *data )
{
  int i;
  word params[28];

  switch( code ){
    case 1 : for( i = 0; i < 28; i ++) params[i] = data[i+1] & 0xFF;
             set_voice_timbre( (int)*data, params );
             break;
    case 2 : set_music_mode( (int)*data );
             break;
    case 3 : set_pitch_range( (int)*data );
             break;
   }
}


/************************
  ‹¡¥¥¸â·¥ £¡—¡ ·¡¥EËa.
*************************/
static void midi_event( word event )
{
  int stat, voice;
  static int data_bytes[ 7 ] = { 2, 2, 2, 2, 1, 1, 2 };

  stat = (event >> 4) & 7;
  voice = event & 0x0F;

  if( voice < MAX_VOICES )
    switch( stat ){
      case 0: note_off( voice );
              break;
      case 1: my_note_on( voice, *music_ptr, *(music_ptr + 1) );
              break;
      case 2: if( current_vol[ voice ] != *(music_ptr + 1) && volume_flag )
                set_voice_volume( voice, *(music_ptr+1) );
              current_vol[voice] = *(music_ptr+1);
              break;
      case 5: if( current_vol[ voice ] == *music_ptr ) break;
              if( volume_flag ) set_voice_volume( voice, *music_ptr );
              current_vol[ voice ] = *music_ptr;
              break;
      case 6: set_voice_pitch( voice, (*(music_ptr + 1) << 7) | *music_ptr );
              break;
     }

  music_ptr += data_bytes[ stat ];
}


/**************************
  ¡AÈa ·¡¥EËaŸi ÀáŸ¡Ðe”a.
***************************/
static void meta_event ()
{
  long l;
  byte *data;

  /* music_ptr points to the event type byte which follows the 0xff. */
  switch( *music_ptr ){
    case END_OF_TRACK : *status = END_OF_TRACK;
                        music_ptr --;
                        break;
    case TEMPO        : music_ptr += 2;
                        l = *music_ptr;
                        l = (l << 8) + *(music_ptr+1);
                        l = (l << 8) + *(music_ptr+2);
                        music_ptr += 3;
                        set_tempo( tick_quarter_note, l );
                        break;
    case SEQ_SPECIFIC : music_ptr ++;       /* event type byte */
                        l = get_length ();
                        data = music_ptr;
                        if( !data[0] && !data[1] && data[2] == 0x3F )
                          adlib_specific( (data[3] << 8) | data[4], &data [5] );
                        music_ptr += l;
                        break;
    default           : music_ptr ++;                 /* event type byte */
                        music_ptr += get_length ();   /* event data */
                        break;
   }
}


/*******************
  £¡—¡ ·¡¥EËa ÀáŸ¡
********************/
static word process_event()
{
  word delay;

  do {
    if( *music_ptr & 0x80 )
      *status = *music_ptr++;

    if( *status == SYSEX_F7 || *status == SYSEX_F0 )
      music_ptr += get_length();
     else
      if( *status == META )
        meta_event();
       else
        midi_event( *status );

    /* Read next delta time. */
    delay = get_next_delay();
   } while( delay == 0 && !end_of_data );

  if( delay )
    return( delay );
   else
    return( 1 );
}


/*******************
  µeºŸi ¯¡¸bÐe”a.
********************/
static void start_music()
{
  music_ptr_ptr = track_ptr;
  status = track_stat;
  end_of_data = FALSE;
  set_tempo( 0, 500000L );

  start_time_out( process_event() );

  _playing_flag = TRUE;
}


/******************************
  Èa·± ´a¶•·¡ –A´ö·i ‰w¶
  ¯©Ð—Ði Ðq®. (timer.asmµA¬á)
*******************************/
word case_time_out( void )
{
  if( !_playing_flag ){
    setup_data( midi_data );
    start_music();
    return( 1 );
   }
   else
    return( process_event() );
}


/*****************
  £¡—¡Ÿi Á¡‹¡ÑÁ
******************/
void init_midi( void )
{
  if( clock_in ) return;

  /* 0388hŸi º­¡¡ YM-3812Ã³·i Á¡‹¡ÑÁ ¯¡Ç¥”a. */
  if( !adlib_init( 0x0388 ) ){
    adlib_ok = FALSE;
    return;
   }

  /* Èa·¡ á ·¥ÈáœóËa 08hŸi Á¡‹¡ÑÁ ¯¡Ç¥”a. */
  clock_install();
  adlib_ok = TRUE;
  clock_in = TRUE;
}


/******************
  £¡—¡Ÿi µeºÐe”a.
*******************/
int play_midi( char *file_name )
{
   int f;
   dword length;

   if( !adlib_ok ) return( 0 );

   if( !clock_in ) return( 1 );
   if( (f = _open( file_name, O_RDONLY )) == CANCEL ){
     adlib_ok = FALSE;
     return( 2 );
    }

   length = filelength( f );
   if( length > 64000 ) length = 64000;
   if( (midi_data = (byte *)farmalloc( length )) == NULL ) return( 3 );
   _read( f, midi_data, length );

   _close( f );

   setup_data( midi_data );
   start_music();
   return( 0 );
}


/********************************************
  Ñe¸ ·q´b·¡ ´é aa »¥Ð—º—·¥ˆaŸi Ÿ¡ÈåÐe”a.
*********************************************/
dword music_position( void )
{
  return( (dword)( music_ptr - midi_data ) );
}


/*******************
  ¥©ŸQ·i »¡¸÷Ðe”a.
********************/
void set_music_volume( word volume )
{
  register int i;

  if( !adlib_ok ) return;

  for( i = 0; i < MAX_VOICES; i++ )
    set_voice_volume( i, volume );
}


/***********************************
  µeºŸi {‰¡ •A·¡ÈáŸi ¹AˆáÐe”a.
************************************/
void stop_music( void )
{
  register int i;

  if( !adlib_ok ) return;

  if( !clock_in ) return;
  _playing_flag = FALSE;

  for( i = 0; i < MAX_VOICES; i++ ){
    set_voice_volume( i, 0 );
    note_off( i );
   }

  set_clock_rate( 0 );     /* Set Orginal Clock */
  farfree( midi_data );
}


/***********************************
 £¡—¡Ÿi {‰¡ ·¥ÈáœóËaŸi ¹AˆáÐe”a.
************************************/
void close_midi()
{
  register int i;

  if( !adlib_ok ) return;

  for( i = 0; i < MAX_VOICES; i++ ){
    set_voice_volume( i, 0 );
    note_off( i );
   }

  if( clock_in ) clock_uninstall();
  clock_in = FALSE;
}

