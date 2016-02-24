" Test g#p with non-default commentstring.

set commentstring=//\ %s
call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "rg#p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
