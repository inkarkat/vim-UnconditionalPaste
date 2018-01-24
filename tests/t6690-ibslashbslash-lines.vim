" Test CTRL-R CTRL-\ CTRL-\ of lines in named register.

call SetRegister('r', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")\n\nCan ...\\foo\\bar\\... be done?\n", 'V')
execute "normal a<\<C-r>\<C-\>\<C-\>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
