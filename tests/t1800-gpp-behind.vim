" Test gpp of number behind cursor in named register.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
