" Test gQBp of a line at buffer borders without unjoin.

call SetRegister('"', "FOO\n", 'V')
normal gg0w1gQBP
normal G0w1gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
