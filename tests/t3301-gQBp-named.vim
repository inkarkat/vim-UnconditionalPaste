" Test gDp of multiple lines in named register.

call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "rgDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
