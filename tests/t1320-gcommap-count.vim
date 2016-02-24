" Test g,p of lines with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "foo\nbar\nb z\n", 'V')
normal "r3g,p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
