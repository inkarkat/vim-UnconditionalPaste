" Test CTRL-R CTRL-Q CTRL-Q CTRL-G CTRL-G of lines with leading and trailing whitespace in named register.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal :let @a = '\<C-r>\<C-q>\<C-q>\<C-g>\<C-g>r'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, "\t    foo \t\tbar   \t  b z \t ", 'pasted register')

call vimtest#Quit()
