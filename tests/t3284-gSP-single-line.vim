" Test gSP on a single line in the buffer.

call SetRegister('r', "foo\n", 'V')
2,$delete _
1normal "rgSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
