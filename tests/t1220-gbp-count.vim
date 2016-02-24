" Test gbp of same-width lines with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "FOO\nBAR\n", 'V')
normal "r3gbp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
