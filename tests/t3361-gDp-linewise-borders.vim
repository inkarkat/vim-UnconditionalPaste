" Test opposite gDp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgDp
normal G0wgDP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
