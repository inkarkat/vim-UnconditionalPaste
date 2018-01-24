" Test g\p of words with choice selected by count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

source helpers/escapes.vim
let b:UnconditionalPaste_Escapes = g:escapes

call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')

normal 1g\P
normal l2g\p
4normal 3g\P

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
