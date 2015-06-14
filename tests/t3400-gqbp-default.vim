" Test gqbp of a word in the default register.

call SetRegister('"', "foobar", 'v')
execute "normal gqbp+-+\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
