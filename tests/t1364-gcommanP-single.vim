" Test g,nP of a single entry.
" Tests that the "comma nor" is placed after the entry, and the "neither" is
" prepended.

call SetRegister('r', "me", 'v')
normal "rg,nP

call vimtest#SaveOut()
call vimtest#Quit()
