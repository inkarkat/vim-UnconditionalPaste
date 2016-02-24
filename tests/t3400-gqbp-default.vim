" Test gqbp of a word in the default register without unjoin.

call SetRegister('"', "foobar", 'v')
execute "normal 1gqbp+-+\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
