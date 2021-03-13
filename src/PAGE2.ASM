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


UDATASEG


DATASEG


CODESEG

;****************************************
;  Ía·¡»¡ ¸åÑÅ·i œa·¥”e¶á¡ ¦…ÐiÐ¬á...
; void activity_page_step( word page, word skip_line, word milli_sec )
;****************************************
proc activity_page_step  page, skip_line, milli_sec : word
  uses ds, es, si, di

  mov [_page_number], 0

  set_page ds, [page]
  mov ax, GRAPH_SEG
  mov es, ax

  mov cx, [skip_line]

  ; ax = cx * H_RES
  mov ax, cx
  xchg ah, al
  mov dx, ax
  shr ax, 2
  add ax, dx

  inc cx
  xor dx, dx
  mov bx, H_RES * V_RES
  sub bx, ax

  cld

 @@all_loop:
  push cx
  mov si, dx
  mov di, dx

 @@loop:
  mov cx, H_RES / 2
  rep movsw
  cmp si, bx
  ja @@next_line
  add si, ax
  mov di, si
  jmp @@loop

 @@next_line:
  push ax dx
  call delay_program, [milli_sec]  ; change ax, cx, dx
  pop dx ax

  add dx, H_RES
  pop cx
  loop @@all_loop

  ret
endp
global activity_page_step : proc


;*******************************
;  Ía·¡»¡ ¡Ÿ¡ ®Íw”e¶á¡ ¥¢¬a
; void copy_page_horiz( word source_page, word target_page, int start_y, int end_y )
;*******************************
proc copy_page_horiz  source_page, target_page, start_y, end_y : word
  uses ds, es, si, di

  set_page es, [target_page]
  set_page ds, [source_page]

  mov ax, [start_y]
  xchg ah, al
  mov si, ax
  shr ax, 2
  add si, ax
  mov di, si

  mov ax, [end_y]
  sub ax, [start_y]
  inc ax
  xchg ah, al
  mov cx, ax
  shr ax, 2
  add cx, ax
  shr cx, 1

  cld
  rep movsw

  ret
endp
global copy_page_step : proc


;************************************
;  ÍA·¡»¡Ÿi Charecter ¤w¯¢·a¡ ¥¢¬a
; void copy_page_char(word source_page, word target_page, int s_x, int s_y, int e_x, int e_y)
;************************************
proc copy_page_char  source_page, target_page, s_x, s_y, e_x, e_y : word
  uses ds, es, si, di

  ; ah ... skip_color
  mov ah, [_attr_null_color]

  set_page es, [target_page]
  set_page ds, [source_page]

  calc_addr si, [s_x], [s_y]
  mov di, si

  mov bx, [e_x]
  sub bx, [s_x]
  inc bx               ; bx ... ·¡£¡»¡· x Ça‹¡
  mov cx, [e_y]
  sub cx, [s_y]
  inc cx               ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa

  mov dx, H_RES
  sub dx, bx     ; dx ... 320 - x_size

 @@y_loop:
  push cx
  mov cx, bx

 @@x_loop:
  lodsb
  cmp al, ah
  je @@skip
  mov [es:di], al
 @@skip:
  inc di
  loop @@x_loop

  add si, dx
  mov di, si
  pop cx
  loop @@y_loop

  ret
endp
global copy_page_char : proc


;************************************
;  ÍA·¡»¡Ÿi Charecter ¤w¯¢·a¡ ¥¢¬a
; void copy_page_char_horiz(word source_page, word target_page, int start_y, int end_y)
;************************************
proc copy_page_char_horiz  source_page, target_page, start_y, end_y : word
  uses ds, es, si, di

  set_page es, [target_page]
  set_page ds, [source_page]

  mov ax, [start_y]
  xchg ah, al
  mov si, ax
  shr ax, 2
  add si, ax
  mov di, si

  mov ax, [end_y]
  sub ax, [start_y]
  inc ax
  xchg ah, al
  mov cx, ax
  shr ax, 2
  add cx, ax

  ; ah ... skip_color
  mov ah, [_attr_null_color]

  cld

 @@loop:
  lodsb
  cmp al, ah
  je @@skip
  mov [es:di], al
 @@skip:
  inc di
  loop @@loop

  ret
endp
global copy_page_char_horiz : proc


;**************************
;  Ía·¡»¡· ·©¦ e·i ¥¢¬a
; void copy_page_cut( word source_page, word target_page, int s_x, int s_y, int e_x, int e_y )
;**************************
proc copy_page_cut  source_page, target_page, s_x, s_y, e_x, e_y : word
  uses ds, es, si, di

  set_page es, [target_page]
  set_page ds, [source_page]
  calc_addr si, [s_x], [s_y]
  mov di, si

  mov bx, [e_x]
  sub bx, [s_x]
  inc bx               ; bx ... ·¡£¡»¡· x Ça‹¡
  mov cx, [e_y]
  sub cx, [s_y]
  inc cx               ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa

  mov dx, H_RES
  sub dx, bx     ; ax ... 320 - x_size

  ; state :
  ;   ds:si ... ­¡¯a Ía·¡»¡· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ¡¢¸â Ía·¡»¡· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@loop:
  mov ax, cx  ; push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add si, dx
  mov di, si
  mov cx, ax  ; pop cx
  loop @@loop

  ret
endp
global copy_page_cut : proc


;***********************************
;  Ía·¡»¡· ·©¦ e·i ”aŸe Ía·¡»¡·
;  ”aŸe ¶áÃ¡¡ ¥¢¬a
; void copy_page_move(word source_page, word target_page, int s_x, int s_y, int e_x, int e_y, int t_x, int t_y)
;***********************************
proc copy_page_move  source_page,target_page, s_x,s_y,e_x,e_y, t_x,t_y : word
  uses ds, es, si, di

  set_page es, [target_page]
  set_page ds, [source_page]

  calc_addr si, [s_x], [s_y]
  calc_addr di, [t_x], [t_y]

  mov cx, [e_y]
  sub cx, [s_y]
  inc cx                ; bx ... ·¡£¡»¡· x Ça‹¡
  mov bx, [e_x]
  sub bx, [s_x]
  inc bx                ; cx ... ·¡£¡»¡· y Ça‹¡Ÿi ­aËa

  mov dx, H_RES
  sub dx, bx            ; ax ... 320 - x_size

  ; state :
  ;   ds:si ... ­¡¯a Ía·¡»¡· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   es:di ... ¡¢¸â Ía·¡»¡· ·¡£¡»¡ ¯¡¸b¦¦…
  ;   bx ... x_size
  ;   cx ... y_size
  ;   dx ... carage (320 - x_size)

  cld

 @@loop:
  mov ax, cx  ; push cx
  mov cx, bx

  shr cx, 1
  jnc @@skip
  movsb
  jcxz @@next
 @@skip:
  rep movsw

 @@next:
  add si, dx
  add di, dx

  mov cx, ax  ; pop cx
  loop @@loop

  ret
endp
global copy_page_move : proc


END
