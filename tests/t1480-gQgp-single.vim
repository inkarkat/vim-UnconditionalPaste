" Test gQgp of a single entry.
" Tests that the tab is placed in front of the entry.

call SetRegister('r', "\t    foo \n", 'v')
normal "rgQgp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
