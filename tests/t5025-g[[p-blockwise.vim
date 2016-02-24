" Test g[[p of block.
" Tests that trailing whitespace is removed.

set autoindent
2,4>
3>

call SetRegister('"', "FOO       \n\tX\nMUCH MOAR", "\<C-v>9")
normal g[[p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
