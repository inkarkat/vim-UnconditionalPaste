" Test gpp of characterwise named register contents with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "42 of 99 have $111.", 'v')
normal "r3gpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
