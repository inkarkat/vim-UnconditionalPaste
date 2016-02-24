" Test g]]P of words in named register.

set autoindent
2,4>
3>

call SetRegister('r', "foo bar", 'v')
normal "rg]]P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
