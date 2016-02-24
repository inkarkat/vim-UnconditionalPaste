" Test gsp of a word in empty line.
" Tests that spaces *are* inserted.

normal! yyp0Dk0D
call SetRegister('"', "FOO", 'v')
normal gsp
normal jgsP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
