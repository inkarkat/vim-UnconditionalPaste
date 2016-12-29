" Test g,np of a single entry.
" Tests that the "comma nor" is placed in front of the entry, and the "neither"
" is omitted.

call SetRegister('r', "me", 'v')
normal "rg,np

call vimtest#SaveOut()
call vimtest#Quit()
