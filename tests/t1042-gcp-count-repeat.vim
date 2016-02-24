" Test repeat with count of gcp of multiple lines in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "rgcp
call VerifyRegister()
normal 3.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
