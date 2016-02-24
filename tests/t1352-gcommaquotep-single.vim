" Test g,"p of a single entry.
" Tests that the comma is placed in front of the entry.
" Tests that only the entry is quoted.

call SetRegister('r', "\t    foo \n\t", 'v')
normal "rg,"p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
