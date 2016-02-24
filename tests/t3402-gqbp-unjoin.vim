" Test gqbp of a word in the default register with unjoin.

call SetRegister('"', "foobar", 'v')
execute "normal gqbp...\\zs\<CR>+-+\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
