" Test g,P of a single entry.
" Tests that the comma is placed after the entry.

call SetRegister('r', "\t    foo \n\t", 'v')
normal "rg,P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
