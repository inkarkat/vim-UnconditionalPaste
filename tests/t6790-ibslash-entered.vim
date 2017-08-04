" Test CTRL-R CTRL-\ of words with entered pattern and replacement.

let b:UnconditionalPaste_Escapes = []

call SetRegister('r', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")\n\nCan ...\\foo\\bar\\... be done?\n", 'V')
execute "normal a<\<C-r>\<C-\>r\<C-u>[ol]\<CR>\<C-u>[&]\<CR>>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
