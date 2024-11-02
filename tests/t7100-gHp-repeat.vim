" Test repeat of gHp with g,p and gpp inside.

let g:UnconditionalPaste_Combinations = [',', 'p']
call SetRegister('"', "2 dollars", 'v')
normal gHp
call VerifyRegister()
normal ...
call VerifyRegister()
normal gHp
call VerifyRegister()
normal .

call vimtest#SaveOut()
call vimtest#Quit()
