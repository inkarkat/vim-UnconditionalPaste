" Test g,p of a single entry with count.
" Tests that the comma is place in front of the entry.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', "\t    foo \n\t", 'v')
normal "r2g,p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
