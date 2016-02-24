" Test CTRL-R CTRL-Q of lines with leading and trailing whitespace in named register.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal :let @a = '\<C-r>\<C-q>r+-+\<CR>'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, 'foo+-+bar+-+b z', 'pasted register')

call vimtest#Quit()
