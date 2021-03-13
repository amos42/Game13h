/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"

#define HEAD_SIZE 26


void init_sb( void );
void interrupt new_irq_vect( void );
void sb_output_dma( voice_data data );
void sb_clear_irq_vect( void );
void output_speaker( voice_data data );
void clear_speaker_vect( void );
void speaker_on( void );
void speaker_off( void );

/* ¬a§i & ¯aÏ¡Äá ‰·¶w */
void (*output_voice)( voice_data data );
void (*close_voice)();

bool _voice_flag   = FALSE;
int  _sound_device = NO_VOICE;


/************************
  ¬a¶…—a —¡¤a·¡¯a Á¡‹¡ÑÁ
*************************/
void init_voice( int sound_dev )
{
  _sound_device = sound_dev;

  switch( sound_dev ){
    case S_BLASTER  : init_sb();
                      sample_rate( 8000 );
                      speaker_on();
                      output_voice = sb_output_dma;
                      close_voice = sb_clear_irq_vect;
                      break;

    case PC_SPEAKER : output_voice = output_speaker;
                      close_voice = clear_speaker_vect;
                      break;

    default         : output_voice = (void *)null_function;
                      close_voice  = (void *)null_function;
                      _sound_device = NO_VOICE;
   }
}


/************************************
  —¡¯aÇaµA¬á VOCÑÁ·©·i ·ª´á —i·¥”a.
*************************************/
int load_voice( char *file_name, voice_data *data )
{
   int f;
   word size;
   char *buffer;

   if( (f = _open( file_name, O_RDONLY )) == CANCEL ){
     data->length = 0;
     return( 1 );
    }

   size = filelength( f ) - HEAD_SIZE;
   if( size > 64000 ) size = 64000;
   if( (buffer = farmalloc( size )) == NULL ) return( 2 );
   data->length = size;
   data->ptr = buffer;
   data->linear_addr = (long)FP_OFF(buffer) + ((long)FP_SEG(buffer) << 4);

   lseek( f, HEAD_SIZE, SEEK_SET );
   _read( f, buffer, size );

   _close( f );
   return( 0 );
}


/**************************************
  VOCŸi ¶áÐ Ði”w–E ¡A¡¡Ÿ¡Ÿi Ð¹AÐe”a.
***************************************/
void free_voice( voice_data *data )
{
  if( data->length )
    farfree( data->ptr );
}

