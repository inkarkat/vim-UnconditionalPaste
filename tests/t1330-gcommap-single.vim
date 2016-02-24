" Test g,p of a single entry.
" Tests that the comma is placed in front of the entry.

call SetRegister('r', "\t    foo \n\t", 'v')
normal "rg,p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
