" Test gQBp of a word at line borders with unjoin.

let g:UnconditionalPaste_UnjoinSeparatorPattern = '\zs'
normal! yy2P
call SetRegister('"', "FOO", 'v')
normal 0gQBP
normal $gQBp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
