" Test g]p of words in named register.

set autoindent
2,4>
3>

call SetRegister('r', "foo bar", 'v')
normal "rg]p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
