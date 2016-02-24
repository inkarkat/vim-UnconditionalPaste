" Test CTRL-R CTRL-C of multiple lines in named register.

call SetRegister('r', "foo\nbar\nb z\n", 'V')
execute "normal a<\<C-r>\<C-c>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
