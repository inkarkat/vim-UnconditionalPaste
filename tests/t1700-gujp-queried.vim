" Test gujp on queried pattern of text in named register.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgujpA\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
