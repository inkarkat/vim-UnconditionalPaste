" Test gBp at the end of line with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

set autoindent expandtab
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n\nMOAR\n", 'V')

3normal $3gBp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
