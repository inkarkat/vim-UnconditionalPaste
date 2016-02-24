" Test gPp of numbers with leading zeros in line.
" Tests that the leading zeros are kept, not swallowed.
" Tests that the number is not interpreted as octal.

call SetRegister('r', "042 of 00099 have $111.\n", 'V')
normal "rgPp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
