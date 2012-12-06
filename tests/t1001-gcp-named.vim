" Test gcp of multiple lines in named register.

call SetRegister('r', "foo\nbar\nbaz\n", 'V')
normal "rgcp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
