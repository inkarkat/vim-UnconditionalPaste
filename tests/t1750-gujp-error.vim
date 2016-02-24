" Test gujp with error in queried pattern.

call SetRegister('r', "FOO   BAR,BAZ,QUUX", 'v')
" XXX: Couldn't get vimtap#err#Throws() to work; assert via msgout.
execute "normal \"rgujp,\\(\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
