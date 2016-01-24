" Test recall of gup.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgup[AQ]\<CR>"
call VerifyRegister()

call SetRegister('s', "MARTARNARQUARA", 'v')
normal 3G"sgUP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
