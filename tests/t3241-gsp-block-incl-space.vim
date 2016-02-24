" Test gsp of a block surrounded by newlines and containing leading and trailing spaces.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', "    \n    \nFOO \n BZ \nQUUX\n    ", "\<C-v>4")
normal 3gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
