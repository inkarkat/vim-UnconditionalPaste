" Test g>p of lines in named register.

set autoindent
2,4>
3>

call SetRegister('r', "FOO\n\tBAR\n\nMOAR STUFF\n", 'V')
normal "rg>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
