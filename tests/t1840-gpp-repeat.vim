" Test repeat of gpp.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "rgpp
call VerifyRegister()
normal ..
normal "rgpp

call vimtest#SaveOut()
call vimtest#Quit()
