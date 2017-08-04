" Test g\p of words with no default.

let b:UnconditionalPaste_Escapes = []

call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')
execute "normal g\\p\<CR>\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
