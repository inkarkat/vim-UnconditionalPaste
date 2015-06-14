" Test repeat of gqbp.

call SetRegister('r', "foobar", 'v')
execute "normal \"rgqbp+-+\<CR>"
call VerifyRegister()
normal hj.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
