" Test gUJp of text surrounded and delimited by multiple delimiters.

let g:UnconditionalPaste_UnjoinSeparatorPattern = '-'
call SetRegister('r', "---foo---bar---", 'v')
normal "rgUJp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
