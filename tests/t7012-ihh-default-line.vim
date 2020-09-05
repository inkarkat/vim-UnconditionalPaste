" Test CTRL-R CTRL-H CTRL-H with default combinations of one line in default register.

set autoindent
2,4>
3>

call SetRegister('"', "foo\n", 'V')
execute "3normal f\<Bar>a\<C-r>\<C-h>\<C-h>\"\<Esc>"
call VerifyRegister()

if v:version < 801 || v:version == 801 && ! has('patch1011') " Vim 8.1.1011: indent from autoindent not removed from blank line
    /) here/-1substitute/^\s\+$//
endif

call vimtest#SaveOut()
call vimtest#Quit()
