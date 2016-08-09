" Test g=p with empty expression.

call SetRegister('"', "foo\nbar\n", 'V')
execute "normal g=p\<C-u>\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
