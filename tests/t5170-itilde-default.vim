" Test CTRL-R ~ of a lowercase word.

call SetRegister('"', 'foobar', 'v')
execute "normal a<\<C-r>~\">\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
