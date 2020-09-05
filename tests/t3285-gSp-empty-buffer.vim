" Test gSp on an empty line in an empty buffer.

call SetRegister('r', "foo\n", 'V')
%delete _
1normal "rgSp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
