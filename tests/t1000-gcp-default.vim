" Test gcp of multiple lines in default register.

call SetRegister('"', "foo\nbar\nbaz\n", 'V')
normal gcp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
