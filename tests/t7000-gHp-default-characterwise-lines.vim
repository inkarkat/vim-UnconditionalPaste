" Test gHp with default combinations of multiple lines in default register.
" Tests that the lines are flattened.

set autoindent
2,4>
3>

call SetRegister('"', "foo\n\there", 'v')
normal gHp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
