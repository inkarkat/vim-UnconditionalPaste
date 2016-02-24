" Test g>P of a word in the default register.

set autoindent
2,4>
3>

call SetRegister('"', "foobar", 'v')
1normal g>P
3normal g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
