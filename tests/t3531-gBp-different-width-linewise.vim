" Test gBp of a multi-line linewise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar\n", 'V')
normal gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
