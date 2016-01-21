" Test gsp of a multi-line selection surrounded by newlines.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "\n\t    \n\t    foo \n\tbar   \n  b z \t \n\n", 'V')
normal 3gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
