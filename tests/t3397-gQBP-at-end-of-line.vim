" Test gQBP at the end of line with a different separator.
" Tests that the special prepend after indent does not apply.

let g:UnconditionalPaste_Separator = '|'
set autoindent expandtab
3,5>
4>
call SetRegister('"', "FOO\nBAR\nBAZ\n", 'V')

3normal $gQBP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
