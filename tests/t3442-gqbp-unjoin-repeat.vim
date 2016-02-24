" Test repeat of gqbp with unjoin.

call SetRegister('r', "foobar", 'v')
execute "normal \"rgqbp...\\zs\<CR>+-+\<CR>"
call VerifyRegister()
normal 2j.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
