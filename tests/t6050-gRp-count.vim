" Test gRp of lines with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('s', "\n\nfoo\n\nbar\n", 'V')
normal 3"sgRp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
