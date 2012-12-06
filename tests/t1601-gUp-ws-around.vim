" Test gUp of whitespace-around and -separated text.

call SetRegister('r', "\t    FOO\nBAR  \t  \n  BAZ\t  \n", 'V')
normal "rgUp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
