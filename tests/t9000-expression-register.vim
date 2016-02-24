" Test linewise pasting of expression register.

execute "normal \"=23+19\<CR>glp"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
