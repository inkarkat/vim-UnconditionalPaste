" Test gpP of number behind cursor in named register.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "rgpP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
