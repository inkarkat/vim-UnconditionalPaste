" Test repeat of gujp.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgujp[AQ]\<CR>"
call VerifyRegister()

normal 2G.
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
