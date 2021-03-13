;*****************************************
;
;     ¡¡—a 13h¶w ‰A·± ¸b¬÷ œa·¡§aœáŸ¡
;                       Ver 4.2
;
;                 ¹A¸b¸a:
;                        º ‰w £¥
;
;  ‰A·± ¸b¬÷·i ¶áÐ  e—e œa·¡§aœáŸ¡¡¬á
; ¡¡—a 13h (320x200, 256) ¸å¶w·¡”a.
;
;*****************************************
IDEAL
include "game13h.inc"

  NB_NOTES          equ 96
  OCTAVE            equ 12
  NB_TABLE_DEMI_TON equ OCTAVE
  NB_STEP_PITCH     equ 16
  LOG_NB_STEP_PITCH equ 4
  TABLE_SIZE        equ (NB_STEP_PITCH * NB_TABLE_DEMI_TON)
  LOG_PITCH         equ 8

  KEYON_BLOCK_FNUM  equ 0B0H
  FNUM_LOW          equ 0A0H

  extrn send_ym3812 : proc

  extrn pitch_range : word


UDATASEG


DATASEG

  function_number_table dw 02B2h
           dw          02B4h,  02B7h,  02B9h,  02BCh,  02BEh,  02C1h,  02C3h
           dw  02C6h,  02C9h,  02CBh,  02CEh,  02D0h,  02D3h,  02D6h,  02D8h
           dw  02DBh,  02DDh,  02E0h,  02E3h,  02E5h,  02E8h,  02EBh,  02EDh
           dw  02F0h,  02F3h,  02F6h,  02F8h,  02FBh,  02FEh,  0301h,  0303h
           dw  0306h,  0309h,  030Ch,  030Fh,  0311h,  0314h,  0317h,  031Ah
           dw  031Dh,  0320h,  0323h,  0326h,  0329h,  032Bh,  032Eh,  0331h
           dw  0334h,  0337h,  033Ah,  033Dh,  0340h,  0343h,  0346h,  0349h
           dw  034Ch,  034Fh,  0352h,  0356h,  0359h,  035Ch,  035Fh,  0362h
           dw  0365h,  0368h,  036Bh,  036Fh,  0372h,  0375h,  0378h,  037Bh
           dw  037Fh,  0382h,  0385h,  0388h,  038Ch,  038Fh,  0392h,  0395h
           dw  0399h,  039Ch,  039Fh,  03A3h,  03A6h,  03A9h,  03ADh,  03B0h
           dw  03B4h,  03B7h,  03BBh,  03BEh,  03C1h,  03C5h,  03C8h,  03CCh
           dw  03CFh,  03D3h,  03D7h,  03DAh,  03DEh,  03E1h,  03E5h,  03E8h
           dw  03ECh,  03F0h,  03F3h,  03F7h,  03FBh,  03FEh, 0FE01h, 0FE03h
           dw 0FE05h, 0FE07h, 0FE08h, 0FE0Ah, 0FE0Ch, 0FE0Eh, 0FE10h, 0FE12h
           dw 0FE14h, 0FE16h, 0FE18h, 0FE1Ah, 0FE1Ch, 0FE1Eh, 0FE20h, 0FE21h
           dw 0FE23h, 0FE25h, 0FE27h, 0FE29h, 0FE2Bh, 0FE2Dh, 0FE2Fh, 0FE31h
           dw 0FE34h, 0FE36h, 0FE38h, 0FE3Ah, 0FE3Ch, 0FE3Eh, 0FE40h, 0FE42h
           dw 0FE44h, 0FE46h, 0FE48h, 0FE4Ah, 0FE4Ch, 0FE4Fh, 0FE51h, 0FE53h
           dw 0FE55h, 0FE57h, 0FE59h, 0FE5Ch, 0FE5Eh, 0FE60h, 0FE62h, 0FE64h
           dw 0FE67h, 0FE69h, 0FE6Bh, 0FE6Dh, 0FE6Fh, 0FE72h, 0FE74h, 0FE76h
           dw 0FE79h, 0FE7Bh, 0FE7Dh, 0FE7Fh, 0FE82h, 0FE84h, 0FE86h, 0FE89h
           dw 0FE8Bh, 0FE8Dh, 0FE90h, 0FE92h, 0FE95h, 0FE97h, 0FE99h, 0FE9Ch
           dw 0FE9Eh, 0FEA1h, 0FEA3h, 0FEA5h, 0FEA8h, 0FEAAh, 0FEADh, 0FEAFh


CODESEG

;*******************************
; Â‰b ºÌa®Ÿi ¬é¸÷Ðe”a.
; int set_freq( int voice, char note, int pitch, int key_on )
;********************************
proc set_freq  voice:word, note:byte, pitch:word, key_on:word
  uses di

  ; signP = (int)pitch - 0x2000;
  mov ax, [pitch]
  sub ax, 2000h
  je @@after_mul

  sar ax, 5
  imul [pitch_range]

 @@after_mul:
  add ah, [note]
  add ax, ( 1 shl (LOG_PITCH - LOG_NB_STEP_PITCH - 1) )

  sar ax, 4
  jge @@l3

  xor ax, ax
  jmp @@l4

 @@l3:
  cmp ax, (NB_NOTES shl LOG_NB_STEP_PITCH) - 1
  jl @@l4
  mov ax, (NB_NOTES shl LOG_NB_STEP_PITCH) - 1

 @@l4:
  mov di, ax
  shr di, 4
  mov dx, di

  ; bl =  di % 12
  push ax
  mov ax, di
  mov bl, 12d
  div bl
  mov bl, ah
  xor bh, bh
  mov di, bx
  pop ax

  shl di, 5
  shl ax, 1
  and ax, (NB_STEP_PITCH*2 - 1)
  add di, ax
  mov ax, [function_number_table + di]

  ; bl = dx / 12
  push ax
  mov ax, dx
  mov bl, 12d
  div bl
  mov bl, al
  dec bl
  pop ax

  or ax, ax
  jge @@l5
  inc bl

 @@l5:
  or bl, bl
  jge @@l6
  inc bl
  sar ax, 1

  ; send_ym3812( 0xA0 + voice, tblValue & 255 );
 @@l6:
  push bx ax
  xor ah, ah
  push ax
  mov al, FNUM_LOW
  add al, [byte voice]
  push ax
  call send_ym3812
  add sp, 4
  pop ax bx

  ; send_ym3812 (0xB0 +voice, key_on + (block << 2) + (tblValue >> 8) & 3);
  mov al, ah
  and al, 3
  shl bl, 2
  add al, bl
  add al, [byte key_on]
  xor ah, ah
  push ax ax
  mov ax, KEYON_BLOCK_FNUM
  add ax, [voice]
  push ax
  call send_ym3812
  add sp, 4
  pop ax

  ret
endp
public set_freq


END
