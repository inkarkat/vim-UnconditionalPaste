" Test gBp of a multi-line selection with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "foo\n   \n\nbaz\n", 'V')
normal 3gBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
