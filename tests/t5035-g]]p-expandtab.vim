" Test g]]p with expandtab.

set ts=8 sts=4 et sw=4 autoindent
2,4>
3>

call SetRegister('"', "\t\tfoo\n\tmuch shorter\n\t    shorter\n\t\t\tmuchlonger\n\t\t    longer\n", 'V')
normal g]]p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
