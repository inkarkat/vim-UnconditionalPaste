" Test opposite gsp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgsp
normal G0wgsP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
