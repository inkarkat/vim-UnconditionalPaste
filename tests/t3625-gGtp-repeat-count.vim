" Test repeat of g>p of lines with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set autoindent
2,4>
3>

call SetRegister('r', "FOO\n\tBAR\n\nMOAR STUFF\n", 'V')
normal "r3g>p
normal j.
$normal 2.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
