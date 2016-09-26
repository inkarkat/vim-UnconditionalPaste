" Test gqp of lines with input of all five parts.

" <ul>\n^M  <li>^M\n^M</li>^M\n</ul>
call SetRegister('r', "\t    foo \n\tbar   \n\t  \n\n  baz \t \n", 'V')
execute "normal \"rgqp<ul>\\n\<C-v>\<CR>  <li>\<C-v>\<CR>\\n\<C-v>\<CR></li>\<C-v>\<CR>\\n</ul>\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
