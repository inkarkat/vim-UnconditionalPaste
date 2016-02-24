" Test gsp of a multi-line characterwise selection with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "foobar\nis here", 'v')
normal 3gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
