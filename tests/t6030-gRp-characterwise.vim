" Test gRp of characterwise multi-line yank.

let g:UnconditionalPaste_GrepPattern = 'o'
call SetRegister('"', "the quick\nbrown fox\n\n\njumps over\nthe lazy\n\n\ndog", 'v')
normal gRp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
