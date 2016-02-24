" Test gBp of a word at line borders without unjoin.

normal! yyP
call SetRegister('"', "FOO", 'v')
normal 01gBP
normal $1gBp

normal! j
normal 01gBp
normal $1gBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
