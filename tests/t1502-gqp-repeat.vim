" Test repeat of gqp.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp+-+\<CR>"
call VerifyRegister()

normal `[2h.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
