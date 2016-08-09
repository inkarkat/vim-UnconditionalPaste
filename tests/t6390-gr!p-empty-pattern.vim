" Test gr!p with empty pattern.

call SetRegister('"', "\t    the quick brown (f_o_x) jumps over the lazy [d_o_g] there", 'v')
execute "normal gr!p\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
