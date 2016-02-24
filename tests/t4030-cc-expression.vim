" Test CTRL-R CTRL-C of expression register.
" Tests that this register is not supported.

let @a = ''
execute "normal :let @a = '\<C-r>\<C-c>='\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, '', 'original register contents')

call vimtest#Quit()
