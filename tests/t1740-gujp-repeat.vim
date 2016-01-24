" Test gup on queried pattern of text in named register.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgupA\<CR>"
call VerifyRegister()
normal .
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
