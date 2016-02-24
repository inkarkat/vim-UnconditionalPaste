" Test opposite gQBp of a line at buffer borders without unjoin.

call SetRegister('"', "FOO\n", 'V')
normal gg0w1gQBp
normal G0w1gQBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
