" Test gR!p with a custom pattern.

let g:UnconditionalPaste_InvertedGrepPattern = '^b'
call SetRegister('r', "foo\nbar\nbaz\n bulli\n", 'V')
normal "rgR!p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
