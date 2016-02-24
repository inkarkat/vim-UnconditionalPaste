" Test gbp of same-width lines in named register.

call SetRegister('r', "FOO\nBAR\n", 'V')
normal "rgbp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
