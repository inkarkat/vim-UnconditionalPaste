" Test recall of gqbp without unjoin.

call SetRegister('r', "foobar", 'v')
execute "normal \"r1gqbp+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "hi\nhoo\nhere\n", 'V')
normal j"sgQBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
