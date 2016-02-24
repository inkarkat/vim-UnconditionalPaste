" Test opposite gSp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgSp
normal G0wgSP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
