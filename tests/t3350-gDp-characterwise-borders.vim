" Test gDp of a word at line borders.

normal! yyP
call SetRegister('"', "FOO", 'v')
normal 0gDP
normal $gDp

normal! j
normal 0gDp
normal $gDP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
