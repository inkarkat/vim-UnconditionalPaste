" Test gdp of a word in the default register.

call SetRegister('"', "foobar", 'v')
execute "normal gdp+-+\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
