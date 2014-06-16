" Test gDp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgDP
normal G0wgDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
