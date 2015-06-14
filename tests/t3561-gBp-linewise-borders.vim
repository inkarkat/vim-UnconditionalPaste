" Test opposite gBp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgBp
normal G0wgBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
