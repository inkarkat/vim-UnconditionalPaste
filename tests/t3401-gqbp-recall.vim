" Test recall of gqbp.

call SetRegister('r', "foobar", 'v')
execute "normal \"rgqbp+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "hi\nhoo\nhere\n", 'V')
normal j"sgQBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
