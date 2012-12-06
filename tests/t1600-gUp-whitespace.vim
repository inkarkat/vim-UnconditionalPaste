" Test gUp of whitespace-separated text in named register.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
normal "rgUp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
