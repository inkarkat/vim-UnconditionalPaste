" Test gpp of number with cursor behind its last digit.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal r.4lr|"rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
