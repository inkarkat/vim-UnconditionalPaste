" Test gqp of lines with input of prefix and suffix.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp[\<C-v>\<CR>, \<C-v>\<CR>]\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
