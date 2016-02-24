" Test recall of CTRL-R CTRL-Q.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal :let @a = '\<C-r>\<C-q>r+-+\<CR>'\<CR>"
call SetRegister('s', "hi\nho\nhere\n", 'V')
execute "normal :let @a = '\<C-r>\<C-q>\<C-q>s'\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(@a, 'hi+-+ho+-+here', 'pasted register')

call vimtest#Quit()
