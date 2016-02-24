" Test repeat of gsp with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "foobar", 'v')
normal 3gsp
normal j04l.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
