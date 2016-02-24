" Test glp of words in named register.

call SetRegister('r', "foo bar", 'v')
normal "rglp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
