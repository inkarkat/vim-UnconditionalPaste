" Test gQBp of a word with separator around without unjoin.

" Tests that no additional separator is inserted at the side with separator.
normal! yy5P
%substitute/\%>2v /\t/g
call SetRegister('"', "FOO", 'v')
3normal! 0f(
normal 1gQBP
normal! j0f(
normal 1gQBp

normal! j0f)
normal 1gQBp
normal! j0f)
normal 1gQBP

" Tests that no additional separator is inserted when separator at both sides.
normal! j0f(r	
normal 1gQBP
normal! j0f(r	h
normal 1gQBp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
