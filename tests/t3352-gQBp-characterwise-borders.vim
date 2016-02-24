" Test gQBp of a word in empty line without unjoin.
" Tests that spaces *are* inserted.

normal! yyp0Dk0D
call SetRegister('"', "FOO", 'v')
normal 1gQBp
normal j1gQBP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
