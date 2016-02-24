" Test gsp of a word with space around.

" Tests that no additional space is inserted at the side with whitespace.
normal! yy5P
call SetRegister('"', "FOO", 'v')
normal! 0f(
normal gsP
normal! j0f(
normal gsp

normal! j0f)
normal gsp
normal! j0f)
normal gsP

" Tests that additional space is inserted when whitespace at both sides.
normal! j0f(r 
normal gsP
normal! j0f(r h
normal gsp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
