" Test g>p of a word in the default register.

set autoindent
2,4>
3>

call SetRegister('"', "foobar", 'v')
normal g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
