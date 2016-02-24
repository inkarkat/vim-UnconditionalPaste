" Test CTRL-R CTRL-U CTRL-U of whitespace-separated text in named register.

call SetRegister('r', "\t    FOO\nBAR  \t  \n  BAZ\t  \n", 'V')
execute "normal a<\<C-r>\<C-u>\<C-u>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
