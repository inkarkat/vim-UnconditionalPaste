" Test g]P variations g[P and g[p.

call SetRegister('r', "foo bar", 'v')
1call append(0, '    a) g]P with characterwise ^')
1normal "rg]P
call VerifyRegister()

call SetRegister('r', "foo\nbar\nb z\n", 'V')
1call append(0, '    b) g[P with linewise ^')
1normal "rg[P
call VerifyRegister()

call SetRegister('r', "FOO   \nB Z   \nQUUX  ", "\<C-v>6")
1call append(0, '    c) g[p with blockwise ^')
1normal "rg[p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
