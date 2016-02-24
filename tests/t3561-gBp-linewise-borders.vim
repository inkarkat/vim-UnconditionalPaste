" Test opposite gBp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0w1gBp
normal G0w1gBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
