" Test g,ap of a single entry.
" Tests that the "comma and" is placed in front of the entry.

call SetRegister('r', "me", 'v')
normal "rg,ap

call vimtest#SaveOut()
call vimtest#Quit()
