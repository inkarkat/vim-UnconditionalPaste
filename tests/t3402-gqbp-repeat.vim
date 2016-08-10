" Test repeat of gqbp without unjoin.

call SetRegister('r', "foobar", 'v')
execute "normal \"r1gqbp+-+\<CR>"
call VerifyRegister()

normal `[2h.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
