" Test gSp on a line consisting of just whitespace.

call SetRegister('r', "foo\n", 'V')
call append(3, "\t")
call append(2, '   ')
4normal "rgSp

4normal "rgSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
