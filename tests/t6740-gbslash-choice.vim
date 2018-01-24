" Test g\p of words with multiple choices.

source helpers/escapes.vim
let b:UnconditionalPaste_Escapes = g:escapes

call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')

let g:IngoLibrary_QueryChoices = [0]
normal g\P
let g:IngoLibrary_QueryChoices = [1]
normal g\p
let g:IngoLibrary_QueryChoices = [2]
4normal g\P

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
