" Test recall of gqp via gQgp.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "\t  hi \n\tho    \n  here \t \n", 'V')
normal `[h"sgQgP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
