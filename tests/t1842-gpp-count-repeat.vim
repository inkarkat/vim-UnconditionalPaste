" Test repeat with count of gpp.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "42 of 99 have $111.\n", 'V')
normal "rgpp
call VerifyRegister()
normal 3.

call vimtest#SaveOut()
call vimtest#Quit()
