" Test gcgp of indented lines in named register.

call SetRegister('r', "\t    foo\n\tbar\n  b z\n", 'V')
normal "rgcgp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
