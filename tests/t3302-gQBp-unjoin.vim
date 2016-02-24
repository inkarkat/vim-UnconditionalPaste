" Test gQBp of a word in the default register with unjoin.

let g:UnconditionalPaste_UnjoinSeparatorPattern = '...\zs'
call SetRegister('"', "foobar", 'v')
normal gQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
