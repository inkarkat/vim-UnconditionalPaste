" Test gUJp of text with no whitespace in named register.
" Tests that nothing is pasted.

call SetRegister('r', "FOO-BAR-BAZ-QUUX", 'v')
normal "rgUJp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
