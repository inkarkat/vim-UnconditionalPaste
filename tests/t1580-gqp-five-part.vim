" Test gqp of lines with input of all five parts.

" Functions:^M^M - ^M()^M! -> Functions:foo() - bar() - baz()! ~
call SetRegister('r', "\t    foo \n\tbar   \n  baz \t \n", 'V')
execute "normal \"rgqpFunctions:\<C-v>\<CR>\<C-v>\<CR> - \<C-v>\<CR>()\<C-v>\<CR>!\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
