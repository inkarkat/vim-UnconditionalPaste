" Test gcp of multiple lines count times in default register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "foo\nbar\nb z\n", 'V')
normal 3gcp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
