" Test g>P with expandtab.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set ts=8 sts=4 et sw=4 autoindent
2,4>
4,5s/^/\t/
3>

call SetRegister('"', "FOO\nX\nMUCH MOAR", "\<C-v>9")
normal 3g>P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
