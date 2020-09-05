" Test g==p of words in default register with unjoin and processing of text between splits.

let g:UnconditionalPaste_Expression = '^\_s\+^substitute(v:val, "\\l", "\\u&", "")'
call SetRegister('"', "the quick brown fox jumps over the lazy dog", 'v')
normal g==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
