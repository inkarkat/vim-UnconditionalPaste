" Test CTRL-R CTRL-H CTRL-H with custom combinations of lines in unnamed register.

let g:UnconditionalPaste_Combinations = ['3U', ',"', '2s']
call SetRegister('"', "foo\nbar\nbaz\n", 'V')

execute "3normal f\<Bar>\"_s\<C-r>\<C-h>\<C-h>\"\<Esc>"
execute "normal oat end'\<C-r>\<C-h>\<C-h>\"\<Esc>"
execute "normal o'at begin\<Home>\<C-r>\<C-h>\<C-h>\"\<Esc>"
execute "normal o\<C-r>\<C-h>\<C-h>\"\<Esc>"
execute "normal omiddle'      'with existing separators\<Home>\<Right>\<Right>\<Right>\<Right>\<Right>\<Right>\<Right>\<Right>\<Right>\<Right>\<C-r>\<C-h>\<C-h>\"\<Esc>"

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
