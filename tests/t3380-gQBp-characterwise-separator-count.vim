" Test gDp with count of a word with separator around.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

" Tests that no additional separator is inserted at the side with separator.
normal! yy5P
%substitute/\%>2v /\t/g
call SetRegister('"', "FOO", 'v')
3normal! 0f(
normal 2gDP
normal! j0f(
normal 2gDp

normal! j0f)
normal 2gDp
normal! j0f)
normal 2gDP

" Tests that no additional separator is inserted when separator at both sides.
normal! j0f(r	
normal 2gDP
normal! j0f(r	h
normal 2gDp

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
