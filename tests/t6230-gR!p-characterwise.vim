" Test gR!p of characterwise multi-line yank.

let g:UnconditionalPaste_InvertedGrepPattern = 'o\|^$'
call SetRegister('"', "the quick\nbrown fox\n\n\njumps over\nthe lazy\n\n\ndog", 'v')
normal gR!p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
