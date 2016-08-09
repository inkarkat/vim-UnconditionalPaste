" Test g==p of a word with count.

call vimtest#SkipAndQuitIf(! vimtest#features#SupportsNormalWithCount(), 'Need support for :normal with count')

let @a = 1
let g:UnconditionalPaste_Expression = 'substitute(v:val, "^", "\\=\"\\n\" . (@a + setreg(''a'', @a + 1))", "")'
call SetRegister('"', "foo", 'v')
normal 5g==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
