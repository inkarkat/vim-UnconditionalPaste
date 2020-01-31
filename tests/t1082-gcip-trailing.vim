" Test gcip of lines with trailing whitespace in named register.

call SetRegister('r', "foo \nbar   \nb z \t \n", 'V')
normal "rgcip
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
