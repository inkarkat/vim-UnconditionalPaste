" Test CTRL-R CTRL-H CTRL-H with default combinations of one line in default register.

set autoindent
2,4>
3>

call SetRegister('"', "foo\n", 'V')
execute "3normal f\<Bar>a\<C-r>\<C-h>\<C-h>\"\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
