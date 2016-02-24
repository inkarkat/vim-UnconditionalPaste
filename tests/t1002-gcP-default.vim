" Test gcP of multiple lines in default register.

call SetRegister('"', "foo\nbar\nb z\n", 'V')
normal gcP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
