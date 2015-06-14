" Test gBp of a word in the default register.

call SetRegister('"', "foobar", 'v')
normal gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
