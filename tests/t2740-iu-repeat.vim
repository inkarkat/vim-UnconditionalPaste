" Test repeat of CTRL-R CTRL-U.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal a<\<C-r>\<C-u>rA\<CR>>\<Esc>"
call VerifyRegister()
normal .
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
