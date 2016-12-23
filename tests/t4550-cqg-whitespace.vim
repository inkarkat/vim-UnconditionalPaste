" Test CTRL-R CTRL-Q CTRL-G of lines with leading and trailing whitespace in named register.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal :let @a = '\<C-r>\<C-q>\<C-g>r+-+\<CR>'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, "\t    foo +-+\tbar   +-+  b z \t ", 'pasted register')

call vimtest#Quit()
