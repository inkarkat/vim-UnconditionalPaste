" Test glP of words in named register.

call SetRegister('r', "foo bar", 'v')
normal "rglP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
