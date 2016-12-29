" Test g,aP of a single entry.
" Tests that the "comma and" is placed after the entry.

call SetRegister('r', "me", 'v')
normal "rg,aP

call vimtest#SaveOut()
call vimtest#Quit()
