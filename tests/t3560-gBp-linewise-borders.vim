" Test gBp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgBP
normal G0wgBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
