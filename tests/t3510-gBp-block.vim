" Test gBp of block in named register.

call SetRegister('r', "FOO \nB  Z\nQUUX", "\<C-v>6")
normal "rgBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
