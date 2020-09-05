" Test CTRL-R CTRL-I of multiple lines in default register.

call SetRegister('"', "foo\nbar\nb z\n", 'V')
execute "normal a<\<C-r>\<C-i>\">\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
