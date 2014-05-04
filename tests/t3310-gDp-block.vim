" Test gDp of block in named register.

call SetRegister('r', "FOO \nB  Z\nQUUX", "\<C-v>6")
normal "rgDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
