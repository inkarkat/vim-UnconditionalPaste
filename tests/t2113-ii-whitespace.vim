" Test CTRL-R CTRL-I of lines with leading and trailing whitespace in named register.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal a<\<C-r>\<C-i>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
