" Test gqp of lines with input of separator that includes one linefeed character.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp]\<C-v>\<C-j>[\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
