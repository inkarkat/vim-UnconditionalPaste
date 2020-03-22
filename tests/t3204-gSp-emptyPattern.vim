" Test gSp with a tweaked empty-pattern.

call SetRegister('r', "foo\n", 'V')
3normal "rgSp

let g:UnconditionalPaste_EmptyLinePattern = '\spadding\s'
3normal "rgSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
