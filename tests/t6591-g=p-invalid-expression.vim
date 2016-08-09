" Test g=p with invalid expression.

call SetRegister('"', "foo\nbar\n", 'V')
" XXX: Couldn't get vimtap#err#Throws() to work; assert via msgout.
execute "normal g=p\<C-u>42 +\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
