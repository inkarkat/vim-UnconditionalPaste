" Test opposite gQBp of a line at buffer borders.

call SetRegister('"', "FOO\n", 'V')
normal gg0wgQBp
normal G0wgQBP
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
