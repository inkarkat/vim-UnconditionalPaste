" Test g>P of multiple lines in the default register.
" Tests that the lines are flattened.

set autoindent
2,4>
3>

call SetRegister('"', "foo\n\there", 'v')
1normal g>P
3normal g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
