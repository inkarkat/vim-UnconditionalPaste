" Test g\\p of words with local Funcref escape.

source helpers/escapes.vim

let b:UnconditionalPaste_Escapes = [{
\   'Replacer': function('MyReplacer')
\}]
call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')
normal g\\p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
