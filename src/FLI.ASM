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

  FLI_HEAD_MARK  = 0AF11h   ; FLI file ¯¢¥i code
  FLI_FRAME_MARK = 0F1FAh   ; FLI frame ¯¢¥i code

  FLI_COLOR  =  11      ; palette updateµA ‰Å‰–E chunk type
  FLI_LC     =  12      ; line compress image data chunk type
  FLI_BLACK  =  13      ; ÑÁ¡e·i black·a¡ setÐa“e chunk type
  FLI_BRUN   =  15      ; RLE compress image data chunk type
  FLI_COPY   =  16      ; non-compress image data chunk type

  struc fli_header_type
    size            dd ?
    type            dw ?
    count           dw ?
    width           dw ?
    height          dw ?
    bit_per_pixel   dw ?
    flags           dw ?
    speed           dw ?
    next_head       dd ?
    frames_in_table dd ?
    file            dw ?
    frame_1_off     dd ?
    strokes         dd ?
    session         dd ?
    unused          db 88 dup(?)
  ends

  struc frame_head_type
    size            dd ?         ; Ðe frame· size
    type            dw ?         ; frame ¯¢¥i code
    chunks          dw ?         ; chunk· ˆ•®
    unused          db 8 dup(?)  ; £¡¬a¶w
  ends

  struc chunk_head_type
    size           dd ?         ; Ðe chunk· size
    type           dw ?         ; chunk type(´aœµa ¸÷·)
  ends

  extrn farmalloc         : proc
  extrn farfree           : proc


UDATASEG

  handle    dw ?
  _fli_head fli_header_type <>
  frame     frame_head_type <>
  chunk     chunk_head_type <>

  public _fli_head


DATASEG

  _fli  fli_state  < 0, 0, 0, 0 >


CODESEG

;*****************************
;  FLI_COLOR Chunk ÀáŸ¡ žË¥
;*****************************
proc process_fli_palette near
  uses ds, si

  mov ds, di

  lodsw    ; skip ! ... (?)
  lodsb
  mov bl, al
  lodsb
  xor ah, ah
  test ax, ax
  jnz @@normal_loop
  mov cx, 256*3
  jmp @@palette_loop
 @@normal_loop:
  mov cx, ax
  shl cx, 1
  add cx, ax  ; cx = ax * 3

 @@palette_loop:
  mov dx, 3C8h
  mov al, bl
  out dx, al
  inc dx

  rep outsb

  ret
endp


;***************************
;  fli_brun chunk ÀáŸ¡žË¥
;***************************
proc process_fli_brun near
  uses ds, es, si, di

  set_page es, [_page_number]
  mov ds, di
  xor di, di

  xor ch, ch
  xor ah, ah

 @@packets:
  lodsb
  mov cl, al

 @@line_brun:
  push cx
  lodsb
  test al, al
  jz @@exit
  js @@no_rle

 @@rle:
  mov cx, ax
  lodsb
  rep stosb
  jmp @@lc_out

 @@no_rle:
  neg al
  mov cx, ax
  rep movsb

 @@lc_out:
  pop cx
  loop @@line_brun

  cmp di, 320*200
  jb @@packets

 @@exit:
  ret
endp


;**************************
; fli_copy chunk ÀáŸ¡žË¥
;**************************
proc process_fli_copy near
  uses ds, es, si, di

  set_page es, [_page_number]
  mov ds, di
  xor di, di

  mov cx, 320*200/2
  rep movsw

  ret
endp


;**************************
;  fli_lc chunk ÀáŸ¡žË¥
;**************************
proc process_fli_lc near
  uses ds, es, si, di

  set_page es, [_page_number]
  mov ds, di

  lodsw
  xchg ah, al
  mov di, ax
  shr ax, 2
  add di, ax

  lodsw
  mov cx, ax  ; Á· œa·¥· ®
  mov dx, di  ; œa·¥· ¯¡¸b º­¡Ÿi ¥¡¹¥
  xor ah, ah  ; ah· hi-§¡ËaŸi ÇiŸ¡´á

 @@total_line_lc:
  push cx
  lodsb
  mov cx, ax
  jcxz @@skip_line

 @@line_lc:
  push cx

  lodsb
  add di, ax
  lodsb
  test al, al
  js @@rle

 @@no_rle:
  mov cx, ax
  rep movsb
  jmp @@next

 @@rle:
  neg al
  mov cx, ax
  lodsb
  rep stosb

 @@next:
  pop cx
  loop @@line_lc

 @@skip_line:
  add dx, 320
  mov di, dx
  pop cx
  loop @@total_line_lc

  ret
endp


;*****************************
;  FLI_BLACK Chunk ÀáŸ¡ žË¥
;*****************************
proc process_fli_black near
  uses es, si

  set_page es, [_page_number]
  xor di, di

  xor ax, ax
  mov cx, 320*200/2
  cld

  rep stosw
  ret
endp


;*************************
;  Ðe Ïaa·±·i ÀáŸ¡Ðe”a.
;*************************
proc one_frame near
  ; _read( handle, &frame, sizeof(frame) )
  mov dx, offset frame
  mov cx, size frame
  mov bx, [handle]
  mov ah, 3Fh
  int 21h

  cmp [frame.type], FLI_FRAME_MARK
  je @@right_frame
  mov ax, 1
  jmp @@exit
 @@right_frame:

  cld
  mov cx, [frame.chunks]
 @@frame_loop:
    push cx

    ; _read( handle, &chunk, sizeof(chunk) );
    mov dx, offset chunk
    mov cx, size chunk
    mov bx, [handle]
    mov ah, 3Fh
    int 21h

    test [chunk.type], FLI_BLACK
    je @@process_frame

    mov si, [word low chunk.size]
    sub si, 6

    call farmalloc, si, 0
    mov di, dx
    mov cx, si   ; cx <= size
    mov si, ax

    push ds
    mov bx, [handle]
    mov ds, di
    mov dx, ax
    mov ah, 3Fh
    int 21h
    pop ds

   @@process_frame:
    mov ax, [chunk.type]

   @@test_fli_color:
    cmp ax, FLI_COLOR
    jne @@test_fli_lc
    call process_fli_palette
    jmp @@end_process

   @@test_fli_lc:
    cmp ax, FLI_LC
    jne @@test_fli_black
    call process_fli_lc
    jmp @@end_process

   @@test_fli_black:
    cmp ax, FLI_BLACK
    jne @@test_fli_brun
    call process_fli_black
    jmp @@end_process

   @@test_fli_brun:
    cmp ax, FLI_BRUN
    jne @@test_fli_copy
    call process_fli_brun
    jmp @@end_process

   @@test_fli_copy:
    cmp ax, FLI_COPY
    jne @@error_fli_chunk
    call process_fli_copy
    jmp @@end_process

   @@error_fli_chunk:
    pop cx
    mov ax, 1
    jmp @@exit

   @@end_process:
    test [chunk.type], FLI_BLACK
    je @@no_free
    call farfree, si, di
   @@no_free:

  pop cx
  ;loop @@frame_loop
  dec cx
  jcxz @@break
  jmp @@frame_loop
 @@break:

  inc [_fli.frame]
  xor ax, ax

 @@exit:
  ret
endp


;***************************
;  ´“¡¡a·¡­e·i »¥Ð—Ðe”a.
; void fli_play( char *fli_name, char mode )
;***************************
proc fli_play  fli_name:dword, mode:byte
  mov [_fli.frame], 0

  push ds
  lds dx, [fli_name]
  mov ax, 3D00h
  int 21h            ; File Open
  pop ds
  jnc @@success
  mov ax, 1
  jmp @@exit

 @@success:
  mov [handle], ax
  mov bx, ax

  mov dx, offset _fli_head
  mov cx, size _fli_head    ; Head Size
  mov ah, 3Fh
  int 21h

  cmp [_fli_head.type], FLI_HEAD_MARK
  je @@fli_loop
  mov ax, 2
  jmp @@exit

 @@fli_loop:
  ; if( _fli.before ) _fli.before()
  mov ax, [word high _fli.before]
  or  ax, [word low  _fli.before]
  jz @@no_first
  call [_fli.before]
 @@no_first:

  ; if( one_frame() ) return( 3 )
  call one_frame
  test ax, ax
  jz @@next
  mov ax, 3
  jmp @@end_play

 @@next:
  ; if( _fli.after ) _fli.after()
  mov ax, [word high _fli.after]
  or  ax, [word low  _fli.after]
  jz @@no_last
  call [_fli.after]
 @@no_last:

  _if_zero [mode], @@no_delay
  mov ax, [_fli_head.speed]
  mov ax, 15
  call delay_program, ax
 @@no_delay:

  mov ax, [word high _fli.stop]
  or  ax, [word low  _fli.stop]
  jnz @@test_stop

  mov ax, [_fli_head.count]
  cmp [_fli.frame], ax
  jb @@fli_loop
  jmp @@end_play

 @@test_stop:
  call [_fli.stop]
  test ax, ax
  jnz @@end_play

  mov ax, [_fli_head.count]
  cmp [_fli.frame], ax
  jb @@fli_loop
  mov [_fli.frame], 0

  ; lseek( handle, sizeof( _fli_head ), SEEK_SET )
  xor cx, cx
  mov dx, size _fli_head
  mov bx, [handle]
  mov ax, 4200h
  int 21h          ; Move file point
  jmp @@fli_loop

 @@end_play:
  mov bx, [handle]
  mov ah, 3Eh
  int 21h          ; File Closed

 @@exit:
  ret
endp
global fli_play : proc


END
