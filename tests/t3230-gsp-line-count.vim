" Test gsp of a multi-line selection with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "\t    foo \n\tbar   \n  b z \t \n", 'V')
normal 3gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
