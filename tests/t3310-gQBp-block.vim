" Test gQBp of block in named register.

call SetRegister('r', "FOO \nB  Z\nQUUX", "\<C-v>4")
normal "rgQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
