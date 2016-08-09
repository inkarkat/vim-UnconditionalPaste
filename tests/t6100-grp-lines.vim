" Test grp of lines in named register.

call SetRegister('r', "\n\t    foo \n\n\n\tbar   \n  b z \t \n\n", 'V')
execute "normal \"rgrp\\sb\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
