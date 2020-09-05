" Test gcip of multiple lines in default register.

call SetRegister('"', "foo\nbar\nb z\n", 'V')
normal gcip
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
