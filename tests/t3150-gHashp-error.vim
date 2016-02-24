" Test g#p with empty commentstring.

set commentstring=
call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "rg#p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
