" Test g==p of lines in named register.

call SetRegister('r', "int main(int argc, char[] argv)\n\nvoid foo(char c, int n)\nvoid finalize()\n", 'V')
normal "rg==p
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
