" Test gcgp of lines including empty lines in named register.

call SetRegister('r', "\t    \n\nfoo \n\n\tbar   \n\n  b z \t \n\n\n", 'V')
normal "rgcgp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
