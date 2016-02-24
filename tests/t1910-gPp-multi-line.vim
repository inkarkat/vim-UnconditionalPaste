" Test gPp of numbers in the second and third lines.

call SetRegister('r', "{\n  42 of 99 have $111.\n  42 of 99 have $111.\n}\n", 'V')
normal "rgPp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
