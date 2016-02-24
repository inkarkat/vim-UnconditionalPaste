" Test g#p of words around indented lines.
" Tests that it acts like ]p, not p.

set commentstring=/*%s*/
set autoindent
2,4>
3>

call SetRegister('r', "foo bar", 'v')
normal "rg#p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
