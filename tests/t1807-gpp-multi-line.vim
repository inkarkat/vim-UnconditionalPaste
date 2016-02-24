" Test gpp of number behind cursor in the second and third lines.

call SetRegister('r', "{\n  42 of 99 have $111.\n  42 of 99 have $111.\n}\n", 'V')
normal "rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
