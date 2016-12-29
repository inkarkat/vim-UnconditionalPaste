" Test g,ap of lines.

call SetRegister('r', "foo\n\tbar \nquux\n", 'V')
call SetRegister('"', "this\nthat\n", 'V')
normal "rg,ap
normal `[h2g,aP

call vimtest#SaveOut()
call vimtest#Quit()
