" Test gQBp of multiple lines in named register.

call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "rgQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
