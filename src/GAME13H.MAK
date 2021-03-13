#
#  Game13h Library MAKE File
#           Chu, Kyong-min


tc_path = c:\language\tc
ta_path = c:\language\asm

.c.obj:
  @$(tc_path)\tcc -c -ml -1 -f- -O -I$(tc_path)\include -E$(ta_path)\tasm.exe $<

.asm.obj:
  @$(ta_path)\tasm /q /m /ml $*


game13h.lib : \
  common.obj tran_var.obj get_data.obj\
  key.obj key_mult.obj mouse.obj joystick.obj\
  image.obj clipping.obj get_img.obj get_im_c.obj put_img.obj img_size.obj img_scal.obj icon.obj\
  copy_put.obj copy_c.obj char_put.obj char_c.obj char_sw.obj char_sd.obj sten_put.obj\
  img_copy.obj img_tran.obj img_flip.obj img_zoom.obj copy_f.obj char_f.obj\
  clr_scr.obj pixel.obj line.obj line2.obj bar.obj bar_sd.obj bar_xor.obj box.obj box_xor.obj\
  scroll.obj scroll2.obj scrl_ful.obj rotate.obj\
  picture.obj incode.obj decode.obj window.obj win_user.obj\
  pal_low.obj palette.obj pal_all.obj fix_pal.obj set_cycl.obj cycl_pal.obj recv_pal.obj chg_pal.obj\
  fade_out.obj fade_in.obj fade_chg.obj gray_pal.obj\
  page.obj page2.obj\
  make_str.obj make_msg.obj font.obj load_fnt.obj input.obj put_fnt.obj put_fntm.obj put_char.obj\
  voc.obj voc_sb.obj voc_spk.obj fli.obj\
  midi.obj set_freq.obj timer.obj adlib.obj\
  xms.obj xms_util.obj\
  util.obj make_s_s.obj menu.obj menu_sml.obj button.obj noise.obj

# Make Library

  @del game13h.lib > NUL
  @tlib game13h.lib /c +common +get_data +tran_var +key +key_mult +mouse +joystick +box +box_xor +bar +bar_sd +bar_xor
  @tlib game13h.lib /c +pixel +clr_scr +line +line2 +scroll +scroll2 +scrl_ful +rotate
  @tlib game13h.lib /c +make_str +make_msg +font +load_fnt +input +put_fnt +put_fntm +put_char
  @tlib game13h.lib /c +get_img +get_im_c +put_img +clipping +copy_put +copy_c +char_put +char_c +char_sw +char_sd+img_scal
  @tlib game13h.lib /c +copy_f +char_f +sten_put +img_size +img_copy +img_tran +img_flip +img_zoom +image +icon
  @tlib game13h.lib /c +picture +decode +incode +window +win_user +noise +palette +pal_low
  @tlib game13h.lib /c +pal_all +fix_pal +cycl_pal +set_cycl +recv_pal +chg_pal +fade_out +fade_in +fade_chg +gray_pal
  @tlib game13h.lib /c +page +page2 +voc +voc_sb +voc_spk +fli +midi +set_freq +timer +adlib
  @tlib game13h.lib /c +xms +xms_util +util +make_s_s +menu +menu_sml +button
  @del game13h.bak > NUL


# Common Module
common.obj   : common.asm    game13h.inc
get_data.obj : get_data.asm  game13h.inc
tran_var.obj : tran_var.asm  game13h.inc

# Input Module
mouse.obj    : mouse.asm     game13h.inc
key.obj      : key.asm       game13h.inc
key_mult.obj : key_mult.asm  game13h.inc
joystick.obj : joystick.asm  game13h.inc

# Image Module
get_img.obj  : get_img.asm   game13h.inc
get_im_c.obj : get_im_c.asm  game13h.inc
put_img.obj  : put_img.asm   game13h.inc
img_size.obj : img_size.asm  game13h.inc
clipping.obj : clipping.asm  game13h.inc
char_put.obj : char_put.asm  game13h.inc
char_c.obj   : char_c.asm    game13h.inc
char_sw.obj  : char_sw.asm   game13h.inc
char_sd.obj  : char_sd.asm   game13h.inc
char_f.obj   : char_f.asm    game13h.inc
copy_put.obj : copy_put.asm  game13h.inc
copy_c.obj   : copy_c.asm    game13h.inc
copy_f.obj   : copy_f.asm    game13h.inc
img_scal.obj : img_scal.asm  game13h.inc
img_copy.obj : img_copy.asm  game13h.inc
img_tran.obj : img_tran.asm  game13h.inc
img_flip.obj : img_flip.asm  game13h.inc
img_zoom.obj : img_zoom.asm  game13h.inc
sten_put.obj : sten_put.asm  game13h.inc
image.obj    : image.c       game13h.h
icon.obj     : icon.c        game13h.h

# Graph Module
clr_scr.obj  : clr_scr.asm  game13h.inc
pixel.obj    : pixel.asm    game13h.inc
line.obj     : line.asm     game13h.inc
line2.obj    : line2.asm    game13h.inc
box.obj      : box.asm      game13h.inc
box_xor.obj  : box_xor.asm  game13h.inc
bar.obj      : bar.asm      game13h.inc
bar_sd.obj   : bar_sd.asm   game13h.inc
bar_xor.obj  : bar_xor.asm  game13h.inc
scroll.obj   : scroll.asm   game13h.inc
scroll2.obj  : scroll2.c    game13h.h
scrl_ful.obj : scrl_ful.asm game13h.inc
rotate.obj   : rotate.c     game13h.h
picture.obj  : picture.c    game13h.h
indode.obj   : incode.asm   game13h.inc
dedode.obj   : decode.asm   game13h.inc
window.obj   : window.c     game13h.h
win_user.obj : win_user.c   game13h.h
noise.obj    : noise.asm    game13h.inc

# Page Module
page.obj    : page.asm      game13h.inc
page2.obj   : page2.asm     game13h.inc

# Palette Module
palette.obj  : palette.c     game13h.h
pal_low.obj  : pal_low.asm   game13h.inc
pal_all.obj  : pal_all.asm   game13h.inc
fix_pal.obj  : fix_pal.asm   game13h.inc
recv_pal.obj : recv_pal.asm  game13h.inc
chg_pal.obj  : chg_pal.asm   game13h.inc
cycl_pal.obj : cycl_pal.asm  game13h.inc
set_cycl.obj : set_cycl.asm  game13h.inc
fade_out.obj : fade_out.c    game13h.h
fade_in.obj  : fade_in.c     game13h.h
fade_chg.obj : fade_chg.c    game13h.h
gray_pal.obj : gray_pal.c    game13h.h

# Hangul Module
make_str.obj : make_str.asm  game13h.inc
font.obj     : font.asm      game13h.inc
input.obj    : input.asm     game13h.inc
put_fnt.obj  : put_fnt.asm   game13h.inc
put_fntm.obj : put_fntm.asm  game13h.inc
put_char.obj : put_char.asm  game13h.inc
load_fnt.obj : load_fnt.c    game13h.h
make_msg.obj : make_msg.c    game13h.h
make_s_s.obj : make_s_s.asm  game13h.inc

# Voc Module
voc.obj      : voc.c         game13h.h
voc_sb.obj   : voc_sb.asm    game13h.inc
voc_spk.obj  : voc_spk.asm   game13h.inc

# Fli Module
fli.obj     : fli.asm        game13h.inc

# Midi Module
midi.obj     : midi.c        game13h.h
set_freq.obj : set_freq.asm  game13h.inc
timer.obj    : timer.asm     game13h.inc
adlib.obj    : adlib.c       game13h.h

# Xms Module
xms.obj      : xms.asm       game13h.inc
xms_util.obj : xms_util.c    game13h.h

# Util Module
util.obj     : util.c        game13h.h
menu.obj     : menu.c        game13h.h
menu_sml.obj : menu_sml.c    game13h.h
button.obj   : button.c      game13h.h
