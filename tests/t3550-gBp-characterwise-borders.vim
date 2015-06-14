" Test gBp of a word at line borders.

normal! yyP
call SetRegister('"', "FOO", 'v')
normal 0gBP
normal $gBp

normal! j
normal 0gBp
normal $gBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
