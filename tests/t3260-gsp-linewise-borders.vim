" Test gsp of a line at line borders.

call SetRegister('"', "FOO\n", 'V')
2normal 0gsP
4normal $gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
