" Test CTRL-R CTRL-C of block in named register.

call SetRegister('r', "FOO   \nB Z   \nQUUX  ", "\<C-v>6")
execute "normal a<\<C-r>\<C-c>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
