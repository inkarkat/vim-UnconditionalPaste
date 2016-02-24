" Test recall of CTRL-R CTRL-Q.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal a<\<C-r>\<C-q>r+-+\<CR>>\<Esc>"
call VerifyRegister()

call SetRegister('s', "hi\nho\nhere\n", 'V')
normal! `[h
execute "normal i<\<C-r>\<C-q>\<C-q>s>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
