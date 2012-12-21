" Test repeat of gpP.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "rgpP
call VerifyRegister()
normal ..
normal "rgpP

call vimtest#SaveOut()
call vimtest#Quit()
