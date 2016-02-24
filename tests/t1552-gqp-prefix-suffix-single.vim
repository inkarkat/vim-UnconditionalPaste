" Test gqp of single entry with input of prefix and suffix.

call SetRegister('r', "\t    foo \n\t", 'v')
execute "normal \"rgqp[\<C-v>\<CR>, \<C-v>\<CR>]\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
