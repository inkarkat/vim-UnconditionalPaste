" Test gQBp of a multi-line linewise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar\n", 'V')
normal gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
