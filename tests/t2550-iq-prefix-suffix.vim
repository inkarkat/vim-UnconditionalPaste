" Test CTRL-R CTRL-Q of lines with input of prefix and suffix.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal a<\<C-r>\<C-q>r[\<C-v>\<CR>, \<C-v>\<CR>]\<CR>>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
