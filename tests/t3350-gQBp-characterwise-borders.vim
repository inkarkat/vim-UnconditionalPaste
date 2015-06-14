" Test gQBp of a word at line borders.

normal! yyP
call SetRegister('"', "FOO", 'v')
normal 0gQBP
normal $gQBp

normal! j
normal 0gQBp
normal $gQBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
