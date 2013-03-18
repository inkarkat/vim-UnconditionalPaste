" Test g]p of words with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "foo bar", 'v')
normal "r3g]p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
