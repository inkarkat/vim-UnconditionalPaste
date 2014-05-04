" Test gDp of a block with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "FOO \nB  Z\nQUUX", "\<C-v>6")
normal 3gDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
