" Test g,op of lines.

call SetRegister('r', "foo\n\tbar \nquux\n", 'V')
normal "rg,np

call vimtest#SaveOut()
call vimtest#Quit()
