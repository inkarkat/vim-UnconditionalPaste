" Test recall of gdp.

call SetRegister('r', "foobar", 'v')
execute "normal \"rgdp+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "hi\nhoo\nhere\n", 'V')
normal j"sgDP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
