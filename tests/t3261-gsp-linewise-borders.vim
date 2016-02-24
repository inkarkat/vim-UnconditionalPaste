" Test opposite gsp of a line at line borders.

call SetRegister('"', "FOO\n", 'V')
2normal 0gsp
4normal $gsP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
