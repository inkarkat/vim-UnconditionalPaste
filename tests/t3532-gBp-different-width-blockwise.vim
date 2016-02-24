" Test gBp of a multi-line linewise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar", "\<C-v>9")
normal gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
