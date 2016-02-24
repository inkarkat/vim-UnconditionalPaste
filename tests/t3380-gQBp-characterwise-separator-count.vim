" Test gQBp with count of a word with separator around.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

" Tests that no additional separator is inserted at the side with separator.
normal! yy5P
%substitute/\%>2v /\t/g
call SetRegister('"', "FOO", 'v')
3normal! 0f(
normal 2gQBP
normal! j0f(
normal 2gQBp

normal! j0f)
normal 2gQBp
normal! j0f)
normal 2gQBP

" Tests that no additional separator is inserted when separator at both sides.
normal! j0f(r	
normal 2gQBP
normal! j0f(r	h
normal 2gQBp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
