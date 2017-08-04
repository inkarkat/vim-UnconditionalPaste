" Test g\p of words with aborted entry.

let b:UnconditionalPaste_Escapes = []

call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')
execute "normal g\\p\<C-u>\<CR>"
execute "normal g\\P\<C-u>o\<CR>\<C-u>\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
