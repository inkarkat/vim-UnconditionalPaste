" Test g,ap of lines with no serial comma.

let g:UnconditionalPaste_IsSerialComma = 0
call SetRegister('r', "foo\n\tbar \nquux\n", 'V')
normal "rg,ap

call vimtest#SaveOut()
call vimtest#Quit()
