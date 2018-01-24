" Test g\\p of lines in named register.

call SetRegister('r', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")\n\nCan ...\\foo\\bar\\... be done?\n", 'V')
normal "rg\\p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
