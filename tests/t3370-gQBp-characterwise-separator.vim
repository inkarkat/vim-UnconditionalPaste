" Test gDp of a word with separator around.

" Tests that no additional separator is inserted at the side with separator.
normal! yy5P
%substitute/\%>2v /\t/g
call SetRegister('"', "FOO", 'v')
3normal! 0f(
normal gDP
normal! j0f(
normal gDp

normal! j0f)
normal gDp
normal! j0f)
normal gDP

" Tests that no additional separator is inserted when separator at both sides.
normal! j0f(r	
normal gDP
normal! j0f(r	h
normal gDp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
