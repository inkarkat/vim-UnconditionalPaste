" Test CTRL-R CTRL-C of indented lines in named register.

call SetRegister('r', "\t    foo\n\tbar\n  b z\n", 'V')
execute "normal a<\<C-r>\<C-c>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
