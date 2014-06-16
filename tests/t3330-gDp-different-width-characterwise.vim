" Test gDp of a multi-line characterwise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar", 'v')
normal gDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
