" Test insert-mode CTRL-R CTRL-H CTRL-H with indent of lines in unnamed register.

set autoindent backspace+=indent
2,4>
3>

let g:UnconditionalPaste_Combinations = ['>']
call SetRegister('"', "foo\n\tbar\nbaz\n", 'V')

execute "3normal f\<Bar>\"_s\<C-r>\<C-h>\<C-h>\"\<Esc>"

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
