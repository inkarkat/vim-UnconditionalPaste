" Test CTRL-R ~ of a non-alphabetical characters.

call SetRegister('r', "%&*#", "\<C-v>4")
execute "normal a\<C-r>~r\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
