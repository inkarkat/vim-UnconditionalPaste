" Test gDP after the last indent of a line extending the buffer.

set autoindent report=0
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n\MOAR\nHERE\n", 'V')

3normal ^gDP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
