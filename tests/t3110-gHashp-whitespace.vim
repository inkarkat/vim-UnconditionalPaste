" Test g#p of lines with leading and trailing whitespace in named register.

set commentstring=/*%s*/
call SetRegister('r', "\n\t    foo \n\tbar   \n\n\n  b z \t \n\t\n\n", 'V')
normal "rg#p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
