" Test g\\p of words with count multiplier.

source helpers/escapes.vim
let b:UnconditionalPaste_Escapes = g:escapes

call SetRegister('r', "Can \"O'Reilly\" come here?\n", 'V')
normal 3"rg\\p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
