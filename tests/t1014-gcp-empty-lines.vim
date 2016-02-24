" Test gcp of lines including empty lines in named register.

call SetRegister('r', "\t    \n\nfoo \n\n\tbar   \n\n  b z \t \n\n\n", 'V')
normal "rgcp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
