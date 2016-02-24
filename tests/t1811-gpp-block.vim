" Test gpp of blockwise named register contents.
" Tests that the virtual column check works on every line now.

call SetRegister('r', "42 of  \n90 have\n$111.  ", "\<C-v>7")
normal "rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
