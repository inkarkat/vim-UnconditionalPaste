" Test gpp of number with cursor behind all numbers.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal r.^r|"rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
