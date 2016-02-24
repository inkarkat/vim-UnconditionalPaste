" Test gpp of number with cursor on the last character of the line.

call SetRegister('r', "42 of 99 in 2000 have $111.\n", 'V')
normal r.$r|"rgpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
