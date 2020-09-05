" Test gCp of blockwise contents with count in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', " FOO  \nB   Z \nQ  X  ", "\<C-v>6")
normal "r3gCp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
