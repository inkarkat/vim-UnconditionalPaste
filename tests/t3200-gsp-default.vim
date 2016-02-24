" Test gsp of a word in the default register.

call SetRegister('"', "foobar", 'v')
normal gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
