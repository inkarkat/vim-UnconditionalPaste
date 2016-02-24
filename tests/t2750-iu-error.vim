" Test CTRL-R CTRL-U with error in queried pattern.

call SetRegister('r', "FOO   BAR,BAZ,QUUX", 'v')
execute "normal a<\<C-r>\<C-u>r,\\(\<CR>>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
