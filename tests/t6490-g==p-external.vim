" Test g==p of lines with external command.

call vimtest#SkipAndQuitIf(! executable('sed'), 'No sed available')

let g:UnconditionalPaste_Expression = '!sed "y/()[]/[]()/"'
call SetRegister('r', "int main(int argc, char[] argv)\n\nvoid foo(char c, int n)\nvoid finalize()\n", 'V')
normal "rg==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
