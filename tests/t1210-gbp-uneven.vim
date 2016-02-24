" Test gbp of uneven-width lines in named register.

call SetRegister('r', "FOO\nBAAAAR\nBZ\n", 'V')
normal "rgbp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
