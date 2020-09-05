" Test gSP on an empty line in an empty buffer.

call SetRegister('r', "foo\n", 'V')
%delete _
1normal "rgSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
