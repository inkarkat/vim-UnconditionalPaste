" Test recall of gqp.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "hi\nho\nhere\n", 'V')
normal `[h"sgQP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
