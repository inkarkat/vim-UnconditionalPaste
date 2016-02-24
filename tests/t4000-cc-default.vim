" Test CTRL-R CTRL-C of multiple lines in default register.

call SetRegister('"', "foo\nbar\nb z\n", 'V')
execute "normal :let @a = '\<C-r>\<C-c>\"'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, 'foo bar b z', 'pasted register')

call vimtest#Quit()
