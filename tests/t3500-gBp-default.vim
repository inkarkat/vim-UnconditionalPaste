" Test gBp of a word in the default register without unjoin.

call SetRegister('"', "foobar", 'v')
normal 1gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
