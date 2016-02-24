" Test repeat of g>p of a word with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set autoindent
2,4>
3>

call SetRegister('"', "foobar", 'v')
normal 3g>p
normal j0.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
