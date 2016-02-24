" Test gSp of a characterwise selection with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "foobar", 'v')
normal 3gSp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
