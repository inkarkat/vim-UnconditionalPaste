" Test gpp of number with cursor on its last digit.

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal r.3lr|"rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
