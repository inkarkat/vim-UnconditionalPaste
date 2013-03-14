" Test gpp of blockwise named register contents.
" Tests that the virtual column check imprecisely does not account for the
" embedded newlines. (But we don't care for this unlikely special case.)

call SetRegister('r', "42 of  \n90 have\n$111.  ", "\<C-v>7")
normal "rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
