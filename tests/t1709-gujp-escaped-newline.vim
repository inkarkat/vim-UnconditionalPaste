" Test gujp with input of separator that includes one escaped newline character.

call SetRegister('r', "FOO   BAR\tBAZ\t QUUX", 'v')
execute "normal \"rgujpR\\t\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(g:UnconditionalPaste_UnjoinSeparatorPattern, 'R\t', 'unjoin separator pattern memorized in original form')

call vimtest#SaveOut()
call vimtest#Quit()
