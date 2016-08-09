" Test recall of g=p.

call SetRegister('r', "int main(int argc, char[] argv)\n\nvoid foo(char c, int n)\nvoid finalize()\n", 'V')
execute "normal \"rg=p\<C-u>toupper(v:val)\<CR>"
call VerifyRegister()

call SetRegister('s', " hi\n bo\n beer\n who\n", 'V')
3normal "sg==P
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
