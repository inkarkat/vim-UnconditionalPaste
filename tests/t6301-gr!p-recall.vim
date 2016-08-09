" Test recall of gr!p.

call SetRegister('r', "\n\t    foo \n\n\n\tbar   \n  b z \t \n\n", 'V')
execute "normal \"rgr!p\\sb\<CR>"
call VerifyRegister()

call SetRegister('s', " hi\n bo\n beer\n who\n", 'V')
3normal "sgR!P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
