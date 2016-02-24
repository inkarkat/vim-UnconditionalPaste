" Test gQp with a custom configured separator.
" Tests that the separator is correctly escaped in substitute().

let g:UnconditionalPaste_JoinSeparator = '&&'
call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
normal "rgQp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
