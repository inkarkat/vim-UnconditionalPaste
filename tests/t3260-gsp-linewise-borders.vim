" Test gsp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgsP
normal G0wgsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
