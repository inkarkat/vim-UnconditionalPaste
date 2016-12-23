" Test gQgp with a custom configured list of prefix, separator, suffix.
" Tests that the elements are dorrectly escaped in substitute().

unlet g:UnconditionalPaste_JoinSeparator
let g:UnconditionalPaste_JoinSeparator = ["\n&", '', ">\n<", '', "&\n"]
call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
normal "rgQgp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
