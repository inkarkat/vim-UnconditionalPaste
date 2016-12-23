" Test gcgp of lines with trailing whitespace in named register.

call SetRegister('r', "foo \nbar   \nb z \t \n", 'V')
normal "rgcgp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
