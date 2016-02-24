" Test CTRL-R CTRL-C of expression register.
" Tests that this register is not supported.

call SetRegister('"', "foo\nbar\nb z\n", 'V')
execute "normal a<\<C-r>\<C-c>=>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
