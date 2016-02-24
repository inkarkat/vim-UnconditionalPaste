" Test recall of CTRL-R CTRL-U.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal a<\<C-r>\<C-u>r[AQ]\<CR>>\<Esc>"
call VerifyRegister()

normal! `[h
call SetRegister('s', "MARTARNARQUARA", 'v')
execute "normal i<\<C-r>\<C-u>\<C-u>s>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
