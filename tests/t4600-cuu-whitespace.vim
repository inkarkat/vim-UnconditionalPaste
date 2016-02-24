" Test CTRL-R CTRL-U CTRL-U of whitespace-separated text in named register.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal :let @a = '\<C-r>\<C-u>\<C-u>r'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, "FOO\nBAR\nBAZ\nQUUX", 'pasted register')

call vimtest#Quit()
