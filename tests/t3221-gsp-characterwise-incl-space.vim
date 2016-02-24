" Test gsp of a word surrounded by whitespace.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('"', " foobar  ", 'v')
normal 3gsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
