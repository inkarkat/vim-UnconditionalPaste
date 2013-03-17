" Test glp of words with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "foo bar", 'v')
normal "r3glp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
