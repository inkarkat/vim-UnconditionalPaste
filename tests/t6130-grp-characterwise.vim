" Test grp of characterwise multi-line yank.

call SetRegister('"', "the quick\nbrown fox\n\n\njumps over\nthe lazy\n\n\ndog", 'v')
execute "normal grpo\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
