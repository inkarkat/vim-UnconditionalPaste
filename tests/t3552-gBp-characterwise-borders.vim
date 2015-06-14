" Test gBp of a word in empty line.

normal! yyp0Dk0D
call SetRegister('"', "FOO", 'v')
normal gBp
normal jgBP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
