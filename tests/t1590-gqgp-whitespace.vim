" Test gqgp of lines with leading and trailing whitespace in named register.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqgp+-+\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
