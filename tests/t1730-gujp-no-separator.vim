" Test gujp on empty queried pattern of text in named register.
" Tests that nothing is pasted.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgujp\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
