" Test CTRL-R CTRL-H CTRL-H with default combinations of lines in named register.

set autoindent
2,4>
3>

call SetRegister('r', "FOO\n\tBAR\n\nMOAR STUFF\n", 'V')
execute "3normal f\<Bar>a\<C-r>\<C-h>\<C-h>r\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
