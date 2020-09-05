" Test g==p with filtering out lines.

let g:UnconditionalPaste_Expression = '.v:val =~# "o" ? [] : v:val'
call SetRegister('"', "the\nquick\nbrown\nfox\njumps\nover\nthe\nlazy\ndog\n", 'V')
normal g==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
