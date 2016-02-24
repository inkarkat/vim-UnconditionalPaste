" Test CTRL-R ~ of a uppercase lines.

call SetRegister('r', "[FOO]\n[BAR]\n", 'V')
execute "normal a\<C-r>~r\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
