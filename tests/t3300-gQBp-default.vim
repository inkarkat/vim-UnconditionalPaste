" Test gQBp of a word in the default register without unjoin.

call SetRegister('"', "foobar", 'v')
normal 1gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
