" Test gSp of a block with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "FOO \nB  Z\nQUUX", "\<C-v>4")
normal 3gSp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
