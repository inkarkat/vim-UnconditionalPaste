" Test CTRL-R CTRL-H CTRL-H with default combinations of multiple lines in default register.
" Tests that the lines are flattened.

set autoindent
2,4>
3>

call SetRegister('"', "foo\n\there", 'v')
execute "3normal f\<Bar>a\<C-r>\<C-h>\<C-h>\"\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
