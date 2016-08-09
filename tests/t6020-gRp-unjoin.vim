" Test gRp of words in default register with unjoin.

let g:UnconditionalPaste_GrepPattern = '^\S\{5}$'
call SetRegister('"', "\t    the quick brown (f_o_x) jumps over the lazy [d_o_g] there", 'v')
normal gRp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
