" Test gsp with a tweaked before and after empty-separator.

normal! m''
call SetRegister('"', "foobar", 'v')

let g:UnconditionalPaste_EmptySeparatorPattern = ['[[:space:]()]', '\s']
normal lgsP
normal ``hgsp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
