" Test CTRL-R CTRL-\ of words with multiple choices.

source helpers/escapes.vim
let b:UnconditionalPaste_Escapes = g:escapes

call SetRegister('r', "Can \"O'Reilly\" come here?", 'v')
call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')

let g:IngoLibrary_QueryChoices = [1]
execute "normal a<\<C-r>\<C-\>r>\<Esc>"

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
