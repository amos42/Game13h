/*****************************************

     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
                       Ver 4.2

                 ¹A¸b¸a:
                        º ‰w £¥

  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
 ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.

*****************************************/
#include "game13h.h"

#pragma inline

/* Parameters of each voice: */
#define PARAM_NUMBER 14

#define prmKsl      0
#define prmMulti    1
#define prmFeedBack 2			/* use for opr. 0 only */
#define prmAttack   3
#define prmSustain  4
#define prmStaining 5			/* Sustaining ... */
#define prmDecay    6
#define prmRelease  7
#define prmLevel    8
#define prmAm       9
#define prmVib      10
#define prmKsr      11
#define prmFm       12			/* use for opr. 0 only */
#define prmWaveSel  13			/* wave select */

/* globals parameters: */
#define prmAmDepth	14
#define prmVibDepth	15
#define prmNoteSel	16
#define prmPercussion	17

/* percussive voice numbers: */
#define BD		6
#define SD		7
#define TOM		8
#define CYMB		9
#define HIHAT		10

#define MAX_VOLUME      0x7F
#define LOG2_VOLUME	7			/* log2( MAX_VOLUME) */
#define MAX_PITCH       0x3FFF
#define MID_PITCH	0x2000

#define MID_C      60
#define CHIP_MID_C 48
#define NR_NOTES   96

#define TOM_PITCH 24
#define TOM_TO_SD 7
#define SD_PITCH (TOM_PITCH + TOM_TO_SD)

#define GetLocPrm( slot, prm ) ( (byte)paramSlot[ slot ][ prm ] )


word gen_addr;
int pitch_range;

static int modeWaveSel;

static char percBits;
static const char percMasks[] = { 0x10, 0x08, 0x04, 0x02, 0x01 };

static char voiceNote[ 9 ];
static char voiceKeyOn[ 9 ];
static word vPitchBend[ 9 ];
static char bxRegister[ 9 ];
static char lVoiceVolume[ 11 ];

static word modeVoices;


/* definition of the ELECTRIC-PIANO voice (opr0 & opr1) */
static char piano_operat0[PARAM_NUMBER] = { 1, 1, 3, 15, 5, 0, 1, 3, 15, 0, 0, 0, 1, 0 };
static char piano_operat1[PARAM_NUMBER] = { 0, 1, 1, 15, 7, 0, 2, 4,  0, 0, 0, 1, 0, 0 };

/* definition of default percussive voices: */
static char bdOpr0[]  = { 0,  0, 0, 10,  4, 0, 8, 12, 11, 0, 0, 0, 1, 0 };
static char bdOpr1[]  = { 0,  0, 0, 13,  4, 0, 6, 15,  0, 0, 0, 0, 1, 0 };
static char sdOpr[]   = { 0, 12, 0, 15, 11, 0, 8,  5,  0, 0, 0, 0, 0, 0 };
static char tomOpr[]  = { 0,  4, 0, 15, 11, 0, 7,  5,  0, 0, 0, 0, 0, 0 };
static char cymbOpr[] = { 0,  1, 0, 15, 11, 0, 5,  5,  0, 0, 0, 0, 0, 0 };
static char hhOpr[]   = { 0,  1, 0, 15, 11, 0, 7,  5,  0, 0, 0, 0, 0, 0 };

static char paramSlot[ 18 ][ PARAM_NUMBER ];    /* all the parameters of slots...  */

static char amDepth;
static char vibDepth;
static char noteSel;
static char percussion;

/* ˆb ÁAéµA Ði”w–E µ¡ÌáA·¡Èá—i· ¤åÑ¡ */
/* ¡I¡—¡ ¡¡—a (9Àé) */
static byte slot_melody_mode[9][2] = {
  {0, 3}, {1, 4}, {2, 5}, {6, 9}, {7, 10}, {8, 11}, {12, 15}, {13, 16}, {14, 17}
 };

/* Èa´b‹¡ ¡¡—a (11Àé) */
static byte slot_percussive_mode[11][2] = {
  {0, 3}, {1, 4}, {2, 5}, {6, 9}, {7, 10}, {8, 11}, {12, 15}, {16, 255}, {14, 255}, {17, 255}, {13, 255}
 };

/* ˆb µ¡ÌáA·¡Ëa· ”·w–A“e ´á—aA¯a µ¡Ïa­U */
static byte slot_offset[18] = { 0,  1,   2,  3,  4,  5,
                                8,  9,  10, 11, 12, 13,
                                16, 17, 18, 19, 20, 21 };

char carrier_slot[] = { 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1 };

static char voiceMSlot[] = {  0, 1, 2,  0, 1, 2,
                              3, 4, 5,  3, 4, 5,
                              6, 7, 8,  6, 7, 8, };

static char voicePSlot[] = {
	0, 1, 2,
	0, 1, 2,
	3, 4, 5,
	3, 4, 5,
	BD, HIHAT, TOM,
	BD, SD, CYMB
 };


void SndSetAllPrm( int slot );
void SndSKslLevel( int slot );
void SndSNoteSel();
void SndSAmVibRhythm();
void SndWaveSelect( int slot );
void UpdateFNums( int voice );
void SetASlotParam( int slot, int param, int val );
void SndSFeedFm( int slot );
void SndSAttDecay( int slot );
void SndSSusRelease( int slot );
void SndSAVEK( int slot );


/***********************************
  »¡¸÷–E º­¡¡ •A·¡ÈáŸi Â‰bÐe”a.
************************************/
void send_ym3812( char addr, char data )
{
  asm MOV DX, WORD PTR gen_addr
  asm MOV AL, BYTE PTR addr
  asm OUT DX, AL

  /* 3.3  a·¡Ça¡ Sec·¡¬w »¡µe */
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX

  asm INC DX
  asm MOV AL, BYTE PTR data
  asm OUT DX, AL
  asm DEC DX

  /* 23  a·¡Ça¡ Sec·¡¬w »¡µe */
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX

  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX

  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX

  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
  asm IN AL, DX
}


static void set_slot_param( word slot, word *param, word waveSel )
{
  int i, k;
  char *ptr;

  for( i = 0, ptr = &paramSlot[slot][0]; i < PARAM_NUMBER - 1; i ++ )
    *ptr++ = *param++;

  *ptr = waveSel &= 0x03;
  SndSetAllPrm( slot );
}


static void set_wave_select( int state )
{
  register int i;

  modeWaveSel = state ? 0x20 : 0;
  for( i = 0; i < 18; i ++ )
    send_ym3812( 0xE0 + slot_offset[i], 0 );

  send_ym3812( 1, modeWaveSel );
}


void set_pitch_range( word range )
{
  if( range > 12 ) range = 12;
  if( range < 1 )  range = 1;

  pitch_range = range;
}


static void set_global_param( int amD, int vibD, int nSel )
{
  amDepth = amD;
  vibDepth = vibD;
  noteSel = nSel;

  SndSAmVibRhythm();
  SndSNoteSel();
}


static void set_char_slot_param( word slot, byte *cParam, word waveSel )
{
  int i;
  word param[ PARAM_NUMBER ];

  for( i = 0; i < PARAM_NUMBER - 1; i ++ )
    param[i] = *cParam++;

  set_slot_param( slot, param, waveSel );
}


static void SndSetPrm( int slot, int prm )
{
  switch( prm ) {
    case prmPercussion:
    case prmAmDepth   :
    case prmVibDepth  : SndSAmVibRhythm();    break;
    case prmNoteSel   : SndSNoteSel();        break;
    case prmKsl       :
    case prmLevel     : SndSKslLevel(slot);   break;
    case prmFm        :
    case prmFeedBack  : SndSFeedFm(slot);     break;
    case prmAttack    :
    case prmDecay     : SndSAttDecay(slot);   break;
    case prmRelease   :
    case prmSustain   : SndSSusRelease(slot); break;
    case prmMulti     :
    case prmVib       :
    case prmStaining  :
    case prmKsr       :
    case prmAm        : SndSAVEK(slot);       break;
    case prmWaveSel   : SndWaveSelect(slot);  break;
   }
}


static void SndSetAllPrm( int slot )
{
  SndSAmVibRhythm();
  SndSNoteSel();
  SndSKslLevel( slot );
  SndSFeedFm( slot );
  SndSAttDecay( slot );
  SndSSusRelease( slot );
  SndSAVEK( slot );
  SndWaveSelect( slot );
}


static void SndSKslLevel( int slot )
{
  byte t1, vc, singleSlot;

  if( percussion )
    vc = voicePSlot[slot];
   else
    vc = voiceMSlot[slot];

  t1 = 63 - ( GetLocPrm( slot, prmLevel ) & 63 );    /* amplitude */
  singleSlot = percussion && vc > BD;

  /* Change the 0 - 127 volume change value to 0 - 63 for the chip.
     (MAX_VOLUME+1)/2 is added to avoid round-off errors. */
  if( carrier_slot[slot] || !GetLocPrm(slot, prmFm) || singleSlot )
    t1 = (t1 * lVoiceVolume [vc] + (MAX_VOLUME+1)/2 ) >> LOG2_VOLUME;

  t1 = 63 - t1;
  t1 |= GetLocPrm(slot, prmKsl) << 6;

  send_ym3812( 0x40 + slot_offset[slot], t1 );
}


static void SndSNoteSel()
{
  send_ym3812( 0x08, noteSel ? 64 : 0 );
}


static void SndSAmVibRhythm()
{
  byte t1;

  t1 = amDepth ? 0x80 : 0;
  t1 |= vibDepth ? 0x40 : 0;
  t1 |= percussion ? 0x20 : 0;
  t1 |= percBits;
  send_ym3812( 0xBD, t1 );
}


static void SndWaveSelect( int slot )
{
  byte wave;

  if( modeWaveSel )
    wave = GetLocPrm( slot, prmWaveSel ) & 0x03;
   else
    wave = 0;

  send_ym3812( 0xE0 + slot_offset[slot], wave );
}


static void UpdateFNums( int voice )
{
  bxRegister[voice] = set_freq( voice, voiceNote[voice], vPitchBend[voice], voiceKeyOn[voice] );
}


static void init_slot_param()
{
  int i;

  for( i = 0; i < 18; i ++ )
    if( carrier_slot[i] )
      set_char_slot_param( i, piano_operat1, 0 );
     else
      set_char_slot_param( i, piano_operat0, 0 );

  if( percussion ){
    set_char_slot_param( 12, bdOpr0, 0 );
    set_char_slot_param( 15, bdOpr1, 0 );
    set_char_slot_param( 16, sdOpr, 0) ;
    set_char_slot_param( 14, tomOpr, 0 );
    set_char_slot_param( 17, cymbOpr, 0 );
    set_char_slot_param( 13, hhOpr, 0 );
   }
}


static void SetASlotParam( int slot, int param, int val )
{
  paramSlot[slot][param] = val;
  SndSetPrm( slot, param );
}


/**********************
  ´b‹¡· ·q¬‚·i »¡¸÷
***********************/
void set_voice_timbre( word voice, word *paramArray )
{
  word wave0, wave1;
  word *prm1, *wavePtr;
  byte *slots;

  if( voice >= modeVoices )  return;

  wavePtr = paramArray + 2 * (PARAM_NUMBER - 1);
  wave0 = *wavePtr++;
  wave1 = *wavePtr;
  prm1 = paramArray + PARAM_NUMBER - 1;

  if (percussion)
    slots = slot_percussive_mode[voice];
   else
    slots = slot_melody_mode[voice];

  set_slot_param( slots[0], paramArray, wave0 );
  if( slots[1] != 255 ) set_slot_param( slots[1], prm1, wave1 );
}


void set_voice_volume( word voice, word volume )
{
  byte *slots;

  if( voice >= modeVoices ) return;
  if( volume > MAX_VOLUME ) volume = MAX_VOLUME;
  lVoiceVolume[voice] = volume;

  if( percussion )
    slots = slot_percussive_mode[voice];
   else
    slots = slot_melody_mode[voice];
  SndSKslLevel( slots[0] );

  if( slots[1] != 255 ) SndSKslLevel( slots[1] );
}


void set_voice_pitch( word voice, word pitchBend )
{
  if( (!percussion && voice < 9) || voice <= BD ){
    /* melodic + bass-drum */
    if( pitchBend > MAX_PITCH ) pitchBend = MAX_PITCH;
    vPitchBend[voice] = pitchBend;
    UpdateFNums( voice );
   }
}


void note_on( word voice, int pitch )
{
  pitch -= (MID_C - CHIP_MID_C);
  if( pitch < 0 ) pitch = 0;

  if( (!percussion && voice < 9) || voice < BD ){
    voiceNote[voice] = pitch;
    voiceKeyOn[voice] = 0x20;
    UpdateFNums(voice);
   } else if( percussion && voice <= HIHAT ){
    if( voice == BD ){
      voiceNote[BD] = pitch;
      UpdateFNums(voice);
     } else if( voice == TOM ){
      if( voiceNote[TOM] != pitch ){
         voiceNote[TOM] = pitch;
         voiceNote[SD] = pitch + TOM_TO_SD;
         UpdateFNums(TOM);
         UpdateFNums(SD);
        }
     }
    percBits |= percMasks[voice - BD];
    SndSAmVibRhythm();
   }
}


void note_off( word voice )
{
  if( (!percussion && voice < 9) || voice < BD ){
    voiceKeyOn[voice] = 0;
    bxRegister[voice] &= ~0x20;
    send_ym3812( 0xB0 + voice, bxRegister[voice] );
   } else if( percussion && voice <= HIHAT ){
      percBits &= ~percMasks[voice - BD];
      SndSAmVibRhythm();
     }
}


static void SndSFeedFm( int slot )
{
  unsigned t1;

  if( carrier_slot[slot] ) return;

  t1 = GetLocPrm( slot, prmFeedBack ) << 1;
  t1 |= GetLocPrm( slot, prmFm) ? 0 : 1;
  send_ym3812( 0xC0 + (int)voiceMSlot[ slot ], t1 );
}


static void SndSAttDecay( int slot )
{
  unsigned t1;

  t1 = GetLocPrm( slot, prmAttack ) << 4;
  t1 |= GetLocPrm( slot, prmDecay ) & 0x0F;
  send_ym3812( 0x60 + (int)slot_offset[ slot ], t1 );
}


static void SndSSusRelease( int slot )
{
  byte t1;

  t1 = GetLocPrm( slot, prmSustain ) << 4;
  t1 |= GetLocPrm( slot, prmRelease ) & 0x0F;
  send_ym3812( 0x80 + slot_offset[ slot ], t1 );
}


static void SndSAVEK( int slot )
{
  byte t1;

  t1 = GetLocPrm( slot, prmAm ) ? 0x80 : 0;
  t1 += GetLocPrm( slot, prmVib ) ? 0x40 : 0;
  t1 += GetLocPrm( slot, prmStaining ) ? 0x20 : 0;
  t1 += GetLocPrm( slot, prmKsr ) ? 0x10 : 0;
  t1 += GetLocPrm( slot, prmMulti ) & 0x0F;
  send_ym3812( 0x20 + slot_offset[ slot ], t1 );
}


/*****************************
  ·q´b µeº ¡¡—aŸi ¬é¸÷.
  TRUE ·¡¡e Èa´b‹¡ ¡¡—a,
  FALSE·¡¡e ¡I¡—¡ ¡¡—a·¡”a.
******************************/
void set_music_mode( int mode )
{
  if( mode ){
    voiceNote[TOM] = TOM_PITCH;
    vPitchBend[TOM] = MID_PITCH;
    UpdateFNums( TOM );

    voiceNote[SD] = SD_PITCH;
    vPitchBend[SD] = MID_PITCH;
    UpdateFNums( SD );
   }

  percussion = mode;
  modeVoices = mode ? 11 : 9;
  percBits = 0;

  init_slot_param();
  SndSAmVibRhythm();
}


static int adlib_board_installed()
{
  unsigned t1, t2, i;

  send_ym3812( 4, 0x60 );    /* mask T1 & T2 */
  send_ym3812( 4, 0x80 );    /* reset IRQ */
  t1 = inportb( gen_addr );  /* read status register */
  send_ym3812( 2, 0xFF );    /* set timer-1 latch */
  send_ym3812( 4, 0x21 );    /* unmask & start T1 */

  for (i = 0; i < 200; i++)   /* 100 uSec delay for timer-1 overflow */
   inportb( gen_addr );

  t2 = inportb( gen_addr );     /* read status register */
  send_ym3812( 4, 0x60 );
  send_ym3812( 4, 0x80 );

  return( (t1 & 0xE0) == 0 && (t2 & 0xE0) == 0xC0 );
}


/***************************
   ´—iŸ³ Äa—aŸi Á¡‹¡ÑÁ.
  ·¡¬w·¡ ´ô·a¡e NULLŸ¡Èå
****************************/
int adlib_init( word port )
{
  register int i;
  int hardware;

  gen_addr = port;
  hardware =  adlib_board_installed();

  if( hardware ) return( 1 );

  for( i = 1; i <= 0xF5; i ++ )
    send_ym3812( i, 0 );             /* ¡¡—e A»¡¯aÈá Á¡‹¡ÑÁ */
  send_ym3812( 4, 6 );               /* mask T1 & T2 */

  for( i = 0; i < 9; i ++ ){         /* pitch bend for each voice = no detune */
    vPitchBend[ i ] = MID_PITCH;
    voiceKeyOn[ i ] = 0;
    voiceNote[ i ]  = 0;
   }

  for( i = 0; i < 11; i ++ )
    lVoiceVolume[ i ] = MAX_VOLUME;

  set_music_mode( 0 );        /* melodic mode */
  set_global_param( 0, 0, 0 );       /* init global parameters */
  set_pitch_range( 1 );         /* default pitch range is 1 half-tone */
  set_wave_select( 1 );

  return( 0 );
}

