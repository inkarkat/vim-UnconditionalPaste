" Test g#p of a word in the default register.

set commentstring=/*\ %s\ */
call SetRegister('"', "foo", 'v')
normal g#p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
