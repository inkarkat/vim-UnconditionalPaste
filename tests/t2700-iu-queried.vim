" Test CTRL-R CTRL-U on queried pattern of text in named register.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal a<\<C-r>\<C-u>rA\<CR>>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
