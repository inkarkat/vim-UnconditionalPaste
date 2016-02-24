" Test gBp of block in named register.

call SetRegister('r', "FOO \nB  Z\nQUUX", "\<C-v>4")
normal "rgBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
