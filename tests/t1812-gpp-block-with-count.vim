" Test gpp of blockwise named register contents with count.
" Tests that the multiplication incorrectly deals with blockwise mode, and
" appends the blocks vertically instead of horizonally. (But we don't care for
" this unlikely special case.)

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "42\n90\n$1", "\<C-v>2")
normal "r2gpp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
