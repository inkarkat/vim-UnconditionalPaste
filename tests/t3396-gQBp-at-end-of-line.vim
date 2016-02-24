" Test gQBp at the end of line with a different separator.

let g:UnconditionalPaste_Separator = '|'
set autoindent
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n", 'V')

3normal $gQBp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
