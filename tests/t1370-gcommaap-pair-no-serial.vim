" Test one line with count of two or two lines resulting in no serial comma.

call SetRegister('"', "single", 'v')
normal 2g,nP

call SetRegister('r', "foo\n\tbar \n", 'V')
normal l"rg,ap

5normal "r2g,aP

call vimtest#SaveOut()
call vimtest#Quit()
