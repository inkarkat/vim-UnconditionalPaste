" Test gcp of indented lines in named register.

call SetRegister('r', "\t    foo\n\tbar\n  b z\n", 'V')
normal "rgcp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
