" Test gBp of a line at buffer borders without unjoin.

call SetRegister('"', "FOO\n", 'V')
normal gg0w1gBP
normal G0w1gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
