" Test gPP of number with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "r3gPP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
