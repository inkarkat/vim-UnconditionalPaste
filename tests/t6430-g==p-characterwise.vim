" Test g==p of characterwise multi-line yank.

let g:UnconditionalPaste_Expression = '.substitute(v:val, "\\l", "\\u&", "")'
call SetRegister('"', "the quick\nbrown fox\n\n\njumps over\nthe lazy\n\n\ndog", 'v')
normal g==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
