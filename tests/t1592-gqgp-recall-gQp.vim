" Test recall of gqgp via gQp.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqgp+-+\<CR>"
call VerifyRegister()

call SetRegister('s', "\t  hi \n\tho    \n  here \t \n", 'V')
normal `[h"sgQP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
