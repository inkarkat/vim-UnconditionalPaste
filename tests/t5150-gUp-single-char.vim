" Test gUp of single character.

call SetRegister('r', 'x', 'v')
normal "rgUp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
