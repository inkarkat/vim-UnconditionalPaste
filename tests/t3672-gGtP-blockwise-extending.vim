" Test g>P of a block extending the buffer.

set autoindent report=0
2,4>
3>

call SetRegister('"', "FOO\nBAR\nBAZ\n\MOAR\nHERE", "\<C-v>4")
normal g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
