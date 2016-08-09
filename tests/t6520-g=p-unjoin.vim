" Test g=p of words in default register with unjoin.

call SetRegister('"', "the quick\tbrown\tfox jumps over the\tlazy\tdog", 'v')
execute "normal g=p \<CR>\<C-u>substitute(v:val, '\\l', '\\u&', '')\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
