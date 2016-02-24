" Test g>p of a block in the default register.

set autoindent
2,4>
3>

call SetRegister('"', "FOO\nX\nMUCH MOAR", "\<C-v>9")
normal g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
