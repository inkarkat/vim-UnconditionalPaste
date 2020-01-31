" Test gcip of a single word with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', 'foobar', 'v')
normal "r3gcip
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
