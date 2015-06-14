" Test gQBp of a word in the default register.

call SetRegister('"', "foobar", 'v')
normal gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
