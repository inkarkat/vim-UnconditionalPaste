" Test gsp of a word at single character line borders.

call setline('.', ['X', 'Y', 'X', 'Y'])
call SetRegister('"', "FOO", 'v')
.  normal gsP
.+1normal gsp

.+1normal gsp
.+1normal gsP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
