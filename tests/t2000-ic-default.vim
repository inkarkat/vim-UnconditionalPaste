" Test CTRL-R CTRL-C of multiple lines in default register.

call SetRegister('"', "foo\nbar\nb z\n", 'V')
execute "normal a<\<C-r>\<C-c>\">\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
