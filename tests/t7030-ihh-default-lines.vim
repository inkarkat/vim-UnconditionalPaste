" Test CTRL-R CTRL-H CTRL-H with default combinations of lines in named register.

set autoindent
2,4>
3>

call SetRegister('r', "FOO\n\tBAR\n\nMOAR STUFF\n", 'V')
execute "3normal f\<Bar>a\<C-r>\<C-h>\<C-h>r\<Esc>"
call VerifyRegister()

if v:version < 801 || v:version == 801 && ! has('patch1011') " Vim 8.1.1011: indent from autoindent not removed from blank line
    /MOAR STUFF/-1substitute/^\s\+$//
    /) here/-1substitute/^\s\+$//
endif

call vimtest#SaveOut()
call vimtest#Quit()
