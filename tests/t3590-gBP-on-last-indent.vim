" Test gBP after the last indent of a line.

set autoindent
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n", 'V')

3normal ^gBP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
