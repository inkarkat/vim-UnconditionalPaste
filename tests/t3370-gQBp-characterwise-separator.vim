" Test gQBp of a word with separator around.

" Tests that no additional separator is inserted at the side with separator.
normal! yy5P
%substitute/\%>2v /\t/g
call SetRegister('"', "FOO", 'v')
3normal! 0f(
normal gQBP
normal! j0f(
normal gQBp

normal! j0f)
normal gQBp
normal! j0f)
normal gQBP

" Tests that no additional separator is inserted when separator at both sides.
normal! j0f(r	
normal gQBP
normal! j0f(r	h
normal gQBp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
