" Test gqp of lines with input of separator that includes one escaped newline character.

call SetRegister('r', "\t    foo \n\tbar   \n  b z \t \n", 'V')
execute "normal \"rgqp]\\n[\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(g:UnconditionalPaste_JoinSeparator, "]\n[", 'join separator memorized in unescaped form')

call vimtest#SaveOut()
call vimtest#Quit()
