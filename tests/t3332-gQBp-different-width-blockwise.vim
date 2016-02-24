" Test gQBp of a multi-line linewise selection with differing widths.

call SetRegister('"', "foo\nx\nmuch moar", "\<C-v>9")
normal gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
