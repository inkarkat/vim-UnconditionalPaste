" Test gR!p of WORDs in default register.

let g:UnconditionalPaste_InvertedGrepPattern = '^\S\{5}$'
call SetRegister('"', "\t    the quick brown (f_o_x) jumps over the lazy [d_o_g] there", 'v')
normal gR!p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
