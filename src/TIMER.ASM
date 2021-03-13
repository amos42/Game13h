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

  extrn case_time_out : proc


UDATASEG

  clock_div_high  dw ?
  clock_div_low   dw ?
  clock_mod       dw ?
  sound_delay     dw ?

  old_int_08 procedure <>


DATASEG

  user_routine_on db FALSE


CODESEG

;*******************************
;  Èa·¡ á —¡¤a·¡”áŸi ¤aŽ…”a.
;  in : bx -- Äa¶…Èá —¡¤a·¡”á.
;*******************************
macro clock_rate
  mov al, 00110110b
  out 43h, al

  mov al, bl
  out 40h, al
  mov al, bh
  out 40h, al
endm


;***********************************
;  ¬¡¶… Çiœâ ·¥ÈáœóËaŸi ¸÷·Ðe”a.
;***********************************
proc new_int_08
  push ds es ax bx cx dx
  cli

  mov ax, DGROUP
  mov ds, ax

  mov ax, [clock_div_high]
  mov bx, [clock_div_low]
  add [clock_mod], bx
  adc ax, 0
  jz @@not_old_vector

  pushf
  call [dword old_int_08]
  jmp @@user_routine

 @@not_old_vector:
  mov al, 20h
  out 20h, al

 @@user_routine:
  dec [sound_delay]
  jnz @@exit

  _if_not_zero [user_routine_on], @@exit

 @@go_user:
  mov [user_routine_on], TRUE
  sti
  call case_time_out
  cli
  mov [user_routine_on], FALSE

  mov bx, [sound_delay]
  neg bx
  cmp bx, ax
  jb @@clock_delay_ok
  mov [sound_delay], 0
  jmp @@go_user

 @@clock_delay_ok:
  add [sound_delay], ax

 @@exit:
  pop dx cx bx ax es ds
  iret
endp


;********************************
;  Á¡”w ¬a·¡Çi ®Ÿi Á¡‹¡ÑÁ Ðe”a.
;     1.119 MHz / count
; voic set_clock_rate( word divid )
;********************************
proc set_clock_rate  divid:word
  pushf
  mov bx, [divid]

  mov [clock_div_low], bx
  mov [clock_div_high], 0
  cmp bx, 1
  adc [clock_div_high], 0

  clock_rate

  popf
  ret
endp
public set_clock_rate


;******************************
;  Çiœâ ·¥ÈáœóËaŸi ·¥¯aÉ©Ðe”a.
; void clock_install(void)
;******************************
proc clock_install
  xor bx, bx
  clock_rate

  mov [clock_div_high], 1
  mov [clock_div_low], bx
  mov [clock_mod], bx

  mov [user_routine_on], FALSE    ; init flag

  push ds es
  mov ax, 3508h
  int 21h
  mov [old_int_08.reg_ip], bx
  mov [old_int_08.reg_cs], es

  mov ax, seg new_int_08
  mov ds, ax
  mov dx, offset new_int_08
  mov ax, 2508h
  int 21h
  pop es ds

  ret
endp
public clock_install


;******************************
;  Èa·¡¤á ·¥ÈáœóËaŸi ¹aˆáÐe”a.
; void clock_uninstall(void)
;*******************************
proc clock_uninstall
  xor bx, bx
  clock_rate

  push ds
  mov ax, 2508h
  lds dx, [dword old_int_08]
  int 21h
  pop ds

  ret
endp
public clock_uninstall


;*******************************************
;  {·i Àx‹¡ ¶áÐ delayŸi Äa¶…Ëa ”a¶…Ðe”a.
;void start_time_out( word delay )
;*******************************************
proc start_time_out  delay:word
  pushf

  mov ax, [delay]
  mov [sound_delay], ax

  popf
  ret
endp
public start_time_out


END
