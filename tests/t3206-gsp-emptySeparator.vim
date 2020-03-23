" Test gsp with a tweaked empty-separator.

normal! m''
call SetRegister('"', "foobar", 'v')
normal gsp

let g:UnconditionalPaste_EmptySeparatorPattern = '[[:space:]()]'
normal ``gsP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
