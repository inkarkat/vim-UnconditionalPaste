" Test gSp of a line from within a fold.

call setline('.', ['blockA1', 'blockA2', 'blockA3', '', '', 'blockB1', 'blockB2', 'blockB3', '', 'blockC1', 'blockC2', '', ''])
call SetRegister('"', "FOO\n", 'V')

3,5fold
8,10fold
12,14fold

12normal gSp
13normal gSP
9normal gSP
4normal gSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
