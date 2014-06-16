" Test gDp of a multi-line characterwise selection with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "foobar\nis here,", 'v')
normal 3gDp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
