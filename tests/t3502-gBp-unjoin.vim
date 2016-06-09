" Test gBp of a word in the default register with unjoin.

call SetRegister('"', "foobar", 'v')
execute "normal gBpo\\zs\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
