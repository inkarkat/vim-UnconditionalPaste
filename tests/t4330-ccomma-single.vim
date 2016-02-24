" Test CTRL-R , of a single entry.

call SetRegister('r', "\t    foo \n\t", 'v')
execute "normal :let @a = '\<C-r>,r'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, 'foo', 'pasted register')

call vimtest#Quit()
