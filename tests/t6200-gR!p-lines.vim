" Test gR!p of lines in named register.

call SetRegister('r', "\n\t    foo \n\n\n\tbar   \n  b z \t \n\n", 'V')
normal "rgR!p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
