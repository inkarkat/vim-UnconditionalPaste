" Test gqp of lines with input of an element suffix.

call SetRegister('r', "\t    foo \n\tbar   \n  baz \t \n", 'V')
execute "normal \"rgqp\<C-v>\<CR>\<C-v>\<CR>\<C-v>\<CR>()\\n{\\n\\n}\\n\<C-v>\<CR>\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
