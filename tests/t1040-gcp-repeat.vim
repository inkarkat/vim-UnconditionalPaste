" Test repeat of gcp of multiple lines in named register.

call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "rgcp
call VerifyRegister()
normal ..

call vimtest#SaveOut()
call vimtest#Quit()
