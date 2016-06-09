" Test gBp of a word in the default register with unjoin.

call vimtest#SkipAndQuitIf(substitute('foobar', 'o\zs', '\n', 'g') !=# "fo\no\nbar", 'substitute() with /o\zs/ is broken')

call SetRegister('"', "foobar", 'v')
execute "normal gBpo\\zs\<CR>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
