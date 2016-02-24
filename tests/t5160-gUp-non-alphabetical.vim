" Test gUp of only non-alphabetical characters.

call SetRegister('r', '123 !@#-+ <>;"[]', 'v')
normal "rgUp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
