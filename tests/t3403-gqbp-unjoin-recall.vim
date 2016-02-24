" Test recall of gqbp with unjoin.

call SetRegister('r', "foobar", 'v')
execute "normal \"rgqbp...\\zs\<CR>+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "hi\nhoo\nhere\n", 'V')
normal 2j"sgQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
