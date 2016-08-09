" Test recall of grp.

call SetRegister('r', "\n\t    foo \n\n\n\tbar   \n  b z \t \n\n", 'V')
execute "normal \"rgrp\\sb\<CR>"
call VerifyRegister()

call SetRegister('s', " hi\n bo\n beer\n who\n", 'V')
3normal "sgRP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
