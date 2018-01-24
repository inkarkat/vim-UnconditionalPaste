" Test g\\p of words with local escape.

let b:UnconditionalPaste_Escapes = [{
\   'pattern': 'o',
\   'replacement': 'X'
\}]
call SetRegister('"', "main(\"f/o/o\", 'b\\a\\r', \"rock'n'roll\")", 'v')
normal g\\p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
