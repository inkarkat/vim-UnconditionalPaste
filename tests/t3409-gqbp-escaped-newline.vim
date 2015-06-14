" Test gqbp of a word with input of separator that includes one escaped newline character.

call SetRegister('"', "foobar", 'v')
execute "normal gqbp&\\n&\<CR>"
call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#Is(g:UnconditionalPaste_Separator, "&\n&", 'separator memorized in unescaped form')

call vimtest#SaveOut()
call vimtest#Quit()
