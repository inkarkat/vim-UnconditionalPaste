" Test g>p with softtabstop.

set ts=8 sts=4 noet sw=4 autoindent
2,4>
3>

call SetRegister('"', "FOO\nX\nMUCH MOAR", "\<C-v>9")
normal g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
