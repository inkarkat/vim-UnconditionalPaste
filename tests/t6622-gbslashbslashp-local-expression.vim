" Test g\\p of words with local expression escape.

let b:UnconditionalPaste_Escapes = [{
\   'Replacer': "'oO[' . tr(v:val, 'o', 'X') . ']Oo'"
\}]
call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')
normal g\\p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
