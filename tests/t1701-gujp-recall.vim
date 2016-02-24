" Test recall of gujp.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgujp[AQ]\<CR>"
call VerifyRegister()

call SetRegister('s', "MARTARNARQUARA", 'v')
normal 3G"sgUJP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
