" Test gsp of a word at line borders.

normal! yyP
call SetRegister('"', "FOO", 'v')
normal 0gsP
normal $gsp

normal! j
normal 0gsp
normal $gsP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
