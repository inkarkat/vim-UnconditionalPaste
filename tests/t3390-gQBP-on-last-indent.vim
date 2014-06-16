" Test gDP after the last indent of a line.

set autoindent
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n", 'V')

3normal ^gDP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
