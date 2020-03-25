" Test gsp with a tweaked before and after empty-separator.

normal! m''
call SetRegister('"', "foobar", 'v')

let g:UnconditionalPaste_EmptySeparatorPattern = ['[[:space:]()]', '\s']
normal gsp
normal ``gsP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
