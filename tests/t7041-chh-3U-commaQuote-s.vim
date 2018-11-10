" Test CTRL-R CTRL-H CTRL-H with custom combinations of lines in unnamed register.

let g:UnconditionalPaste_Combinations = ['3U', ',"', '2s']
call SetRegister('"', "foo\nbar\nbaz\n", 'V')

call vimtest#StartTap()
call vimtap#Plan(5)

execute "normal :let @a = ''\<Left>\<C-r>\<C-h>\<C-h>\"\<CR>"
call vimtap#Is(@a, '  "Foo", "Bar", "Baz"  ', 'pasted in middle')

execute "normal :let @a = '\<C-r>\<C-h>\<C-h>\"'\<CR>"
call vimtap#Is(@a, '  "Foo", "Bar", "Baz"', 'pasted at end')

execute "normal :'\<Left>\<C-r>\<C-h>\<C-h>\"\<Home>let @a = '\<CR>"
call vimtap#Is(@a, '"Foo", "Bar", "Baz"  ', 'pasted at begin')

execute "normal :\<C-r>\<C-h>\<C-h>\"'\<Home>let @a = '\<CR>"
call vimtap#Is(@a, '  "Foo", "Bar", "Baz"  ', 'pasted at empty')

execute "normal :let @a = '      '\<Left>\<Left>\<Left>\<Left>\<C-r>\<C-h>\<C-h>\"\<CR>"
call vimtap#Is(@a, '     "Foo", "Bar", "Baz"     ', 'pasted in middle with existing separators left and right')

call vimtest#Quit()
