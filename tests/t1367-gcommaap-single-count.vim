" Test g,ap of a single entry with count.

call SetRegister('r', "me", 'v')
normal "r3g,ap

call vimtest#SaveOut()
call vimtest#Quit()
