" Test gup of a two full words of multiple words in named register.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

call SetRegister('r', ":: My FOO Is ::\nBar\nBaz\n", 'V')
normal "r4gup
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
