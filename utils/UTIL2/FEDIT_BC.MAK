#
#  Font Editor MAKE File
#           Chu, Kyong-min


path = c:\devel\bc31

.c.obj:
  @$(path)\bin\bcc -c -ml -1 -f- -O -I$(path)\include $<


fedit.exe    : f_edit.obj f_select.obj f_main.obj

  @$(path)\bin\tlink /c /x $(path)\lib\c0l.obj f_edit f_select f_main, fedit.exe,, $(path)\lib\cl.lib $(path)\lib\game13h.lib


f_edit.obj   : f_edit.c   $(path)\include\game13h.h
f_select.obj : f_select.c $(path)\include\game13h.h
f_main.obj   : f_main.c   $(path)\include\game13h.h

