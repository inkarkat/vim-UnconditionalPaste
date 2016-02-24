" Test gBp of a word in empty line without unjoin.

normal! yyp0Dk0D
call SetRegister('"', "FOO", 'v')
normal 1gBp
normal j1gBP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
