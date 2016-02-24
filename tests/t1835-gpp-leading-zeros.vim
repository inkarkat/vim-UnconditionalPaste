" Test gpp of number with leading zeros behind cursor.
" Tests that the leading zeros are kept, not swallowed.
" Tests that the number is not interpreted as octal.

call SetRegister('r', "42 of 00099 have $111.\n", 'V')
normal "rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
