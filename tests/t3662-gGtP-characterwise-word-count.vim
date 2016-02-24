" Test g>P of a word with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set autoindent
2,4>
3>

call SetRegister('"', "foobar", 'v')
1normal 3g>P
3normal 3g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
