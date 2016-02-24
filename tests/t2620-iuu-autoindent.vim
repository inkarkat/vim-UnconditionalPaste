" Test CTRL-R CTRL-U CTRL-U of whitespace-separated text with auto-indent.

setlocal autoindent
call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal a\<CR>\<Tab><\<C-r>\<C-u>\<C-u>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
