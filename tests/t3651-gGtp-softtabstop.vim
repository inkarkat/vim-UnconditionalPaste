" Test g>p with softtabstop.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set ts=8 sts=4 noet sw=4 autoindent
4,5s/$/   /
2,4>
3>

call SetRegister('"', "FOO\nX\nMUCH MOAR", "\<C-v>9")
normal 3g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
