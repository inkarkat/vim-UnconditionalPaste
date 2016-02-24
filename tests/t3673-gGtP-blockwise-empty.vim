" Test g>P of a block to empty lines.
" Tests that there's no trailing whitespace on the empty line.

set autoindent
2,4>
4s/.*//
3>

call SetRegister('"', "FOO\nX\nMOAR", "\<C-v>9")
normal g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
