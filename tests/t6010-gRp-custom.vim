" Test gRp with a custom pattern.

let g:UnconditionalPaste_GrepPattern = '^b'
call SetRegister('r', "foo\nbar\nbaz\n bulli\n", 'V')
normal "rgRp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
