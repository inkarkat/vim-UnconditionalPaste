" Test g,op of lines.

call SetRegister('r', "foo\n\tbar \nquux\n", 'V')
normal "rg,op

call vimtest#SaveOut()
call vimtest#Quit()
