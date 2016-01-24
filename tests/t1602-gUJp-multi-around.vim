" Test gUp of text surrounded and delimited by multiple delimiters.

let g:UnconditionalPaste_UnjoinSeparatorPattern = '-'
call SetRegister('r', "---foo---bar---", 'v')
normal "rgUp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
