" Test g=p of lines in named register.

call SetRegister('r', "int main(int argc, char[] argv)\n\nvoid foo(char c, int n)\nvoid finalize()\n", 'V')
execute "normal \"rg=p\<C-u>toupper(v:val)\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
