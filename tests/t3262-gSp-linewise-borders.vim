" Test gSp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgSP
normal G0wgSp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
