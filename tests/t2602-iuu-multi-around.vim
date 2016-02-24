" Test CTRL-R CTRL-U CTRL-U of text surrounded and delimited by multiple delimiters.

let g:UnconditionalPaste_UnjoinSeparatorPattern = '-'
call SetRegister('r', "---foo---bar---", 'v')
execute "normal a<\<C-r>\<C-u>\<C-u>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
