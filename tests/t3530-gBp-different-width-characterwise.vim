" Test gBp of a multi-line characterwise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar", 'v')
normal gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
