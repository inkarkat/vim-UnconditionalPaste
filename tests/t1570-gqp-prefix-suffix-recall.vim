" Test recall of gqp of lines with input of separator that includes one linefeed character.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp[\<C-v>\<CR>, \<C-v>\<CR>]\<CR>"
call VerifyRegister()

call SetRegister('s', "hi\nho\nhere\n", 'V')
normal `[h"sgQP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
