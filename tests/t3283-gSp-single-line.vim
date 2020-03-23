" Test gSp on a single line in the buffer.

call SetRegister('r', "foo\n", 'V')
2,$delete _
1normal "rgSp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
