" Test g==p with a custom expression.

let g:UnconditionalPaste_Expression = 'toupper(v:val)'
call SetRegister('r', "int main(int argc, char[] argv)\n\nvoid foo(char c, int n)\nvoid finalize()\n", 'V')
normal "rg==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
