" Test g>P with a block containing longer subsequent lines.

set autoindent
2,4>
3>

call SetRegister('"', "FOO\nX\nMUCH MOAR", "\<C-v>9")
normal g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
