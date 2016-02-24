" Test repeat of CTRL-R CTRL-C.

call SetRegister('r', "foo\nbar\nb z\n", 'V')
execute "normal a<\<C-r>\<C-c>r>\<Esc>"
call VerifyRegister()
normal .
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
