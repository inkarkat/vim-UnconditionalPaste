" Test gQBp of a word in empty line.
" Tests that spaces *are* inserted.

normal! yyp0Dk0D
call SetRegister('"', "FOO", 'v')
normal gQBp
normal jgQBP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
