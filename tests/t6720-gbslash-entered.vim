" Test g\p of words with entered pattern and replacement.

let b:UnconditionalPaste_Escapes = []

call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')
execute "normal g\\p\<C-u>[ol]\<CR>\<C-u>[&]\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
