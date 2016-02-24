" Test g,'P of lines with empty ones and whitespace.

call SetRegister('r', "  foo\n\n bar \n\nb z\n\n\nend \t  \n", 'V')
normal "rg,'P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
