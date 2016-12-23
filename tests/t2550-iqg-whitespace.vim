" Test CTRL-R CTRL-Q CTRL-G of lines with leading and trailing whitespace in named register.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal a<\<C-r>\<C-q>\<C-g>r+-+\<CR>>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
