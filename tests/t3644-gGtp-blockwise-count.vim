" Test g>p of a block with count to longer subsequent lines.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set autoindent
2,4>
4>
4>
4>
4>
3>

call SetRegister('"', "FOO\nX\nMUCH MOAR", "\<C-v>9")
normal 3g>p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
