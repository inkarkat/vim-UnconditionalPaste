" Test gQp of a single entry.
" Tests that the tab is placed in front of the entry.

call SetRegister('r', "\t    foo \n\t", 'v')
normal "rgQp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
