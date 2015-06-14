" Test gQBp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgQBP
normal G0wgQBp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
