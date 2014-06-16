" Test gDp of a word in the default register.

call SetRegister('"', "foobar", 'v')
normal gDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
