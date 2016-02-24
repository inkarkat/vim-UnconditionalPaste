" Test gUJp of whitespace-around and -separated text.

call SetRegister('r', "\t    FOO\nBAR  \t  \n  BAZ\t  \n", 'V')
normal "rgUJp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
