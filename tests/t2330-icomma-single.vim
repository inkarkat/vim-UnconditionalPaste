" Test CTRL-R , of a single entry.
" Tests that the special placement of a comma in front of the entry does not
" apply to insert mode mappings.

call SetRegister('r', "\t    foo \n\t", 'v')
execute "normal a<\<C-r>,r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
