" Test gpp of text with no number.
" Tests that nothing is pasted.

call SetRegister('r', "xx of yy have $zzz.\n", 'V')
normal "rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
