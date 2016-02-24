" Test CTRL-R CTRL-C of lines with trailing whitespace in named register.

call SetRegister('r', "foo \nbar   \nb z \t \n", 'V')
execute "normal a<\<C-r>\<C-c>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
