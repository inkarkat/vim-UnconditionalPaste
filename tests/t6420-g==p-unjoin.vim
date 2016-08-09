" Test g==p of words in default register with unjoin.

let g:UnconditionalPaste_Expression = 'substitute(v:val, "\\l", "\\u&", "")'
call SetRegister('"', "the quick brown fox jumps over the lazy dog", 'v')
normal g==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
