" Test gQBp of a multi-line characterwise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar", 'v')
normal gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
