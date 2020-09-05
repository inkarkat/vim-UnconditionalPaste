" Test gSp with tweaked above and below empty-patterns.

call SetRegister('r', "foo\n", 'V')

let g:UnconditionalPaste_EmptyLinePattern = ['\spadding\s', '^\s*$']
3normal "rgSp
3normal "rgSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
