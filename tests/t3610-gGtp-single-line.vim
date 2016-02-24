" Test g>p of a single lines in the default register.

set autoindent
2,4>
3>

call SetRegister('"', "FOO\n", 'V')
normal g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
