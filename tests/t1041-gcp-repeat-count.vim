" Test repeat of gcp with count of multiple lines in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "r3gcp
call VerifyRegister()
normal .
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
