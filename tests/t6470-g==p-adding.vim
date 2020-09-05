" Test g==p with adding of new lines.

let g:UnconditionalPaste_Expression = '.v:val =~# "o" ? ["<<<", v:val, v:val, ">>>"] : v:val'
call SetRegister('"', "the\nquick\nbrown\nfox\njumps\nover\nthe\nlazy\ndog\n", 'V')
normal g==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
