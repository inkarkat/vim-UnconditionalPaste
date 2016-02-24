" Test g#p of multiple lines with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set commentstring=/*%s*/
call SetRegister('r', "foo\n    bar\n", 'V')
normal "r3g#p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
