" Test gSp of a word in the default register.

call SetRegister('"', "foobar", 'v')
normal gSp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
