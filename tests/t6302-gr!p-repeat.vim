" Test repeat of gr!p.

call SetRegister('r', "\n\t    foo \n\n\n\tbar   \n  b z \t \n\n", 'V')
execute "normal \"rgr!p\\sb\<CR>"
call VerifyRegister()

2normal .
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
