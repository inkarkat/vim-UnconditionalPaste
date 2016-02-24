" Test gup of a block in unnamed register.

call SetRegister('"', "--- \nB  Z\nQUUX", "\<C-v>4")
normal gup
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
