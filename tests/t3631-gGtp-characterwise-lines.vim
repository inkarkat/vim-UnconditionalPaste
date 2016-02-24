" Test g>p of multiple lines in the default register.
" Tests that the lines are flattened.

set autoindent
2,4>
3>

call SetRegister('"', "foo\n\there", 'v')
normal g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
