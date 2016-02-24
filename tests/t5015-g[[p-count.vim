" Test g[[p of lines with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set autoindent
2,4>
3>

call SetRegister('"', "\t\tfoo\n\tshorter\n\t\t\tlonger\n", 'V')
normal 2g[[p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
