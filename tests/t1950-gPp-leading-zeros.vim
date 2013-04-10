" Test gPp of numbers in line.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "rgPp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
