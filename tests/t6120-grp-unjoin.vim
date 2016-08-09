" Test grp of words in default register with unjoin.

call SetRegister('"', "\t    the quick brown (f_o_x) jumps over the lazy [d_o_g] there", 'v')
execute "normal grp \<CR>^\\S\\{5}$\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
