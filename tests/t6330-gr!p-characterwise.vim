" Test gr!p of characterwise multi-line yank.

call SetRegister('"', "the quick\nbrown fox\n\n\njumps over\nthe lazy\n\n\ndog", 'v')
execute "normal gr!po\\|^$\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
