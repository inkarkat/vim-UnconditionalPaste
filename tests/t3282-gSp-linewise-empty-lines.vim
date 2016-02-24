" Test gSp of a line with empty lines around.

call setline('.', ['---', '', 'stuff', '---', '', 'stuff', '---', 'stuff', '', '---', 'stuff', '', '---', '', '', '---', '', ''])
call SetRegister('"', "FOO\n", 'V')

" Tests that additional lines are inserted when empty lines at both sides.
19normal gSp
17normal gSP

" Tests that no additional line is inserted at the side with empty line.
13normal gSp
11normal gSP

7normal gSp
5normal gSP

call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
