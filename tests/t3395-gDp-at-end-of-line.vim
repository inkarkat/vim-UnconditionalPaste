" Test gDp at the end of the line.

set autoindent
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n", 'V')

3normal $gDp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
