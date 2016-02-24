" Test gQBp of a word at line borders without unjoin.

normal! yyP
call SetRegister('"', "FOO", 'v')
normal 01gQBP
normal $1gQBp

normal! j
normal 01gQBp
normal $1gQBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
