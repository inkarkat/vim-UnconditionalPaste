" Test gsp of a multi-line characterwise selection surrounded by whitespace.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', " foobar\t\n  is here\t ", 'v')
normal 3gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
