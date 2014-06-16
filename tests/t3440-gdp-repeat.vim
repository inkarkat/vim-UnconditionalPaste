" Test repeat of gdp.

call SetRegister('r', "foobar", 'v')
execute "normal \"rgdp+-+\<CR>"
call VerifyRegister()
normal hj.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
