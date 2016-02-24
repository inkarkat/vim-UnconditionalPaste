" Test CTRL-R CTRL-C of multiple lines with auto-formatting.

setlocal textwidth=40
setlocal formatoptions=tcq
call SetRegister('r', "foo with a lot of text in here\nbar has even more words for us\nb z is strange, but again quite wordy\n", 'V')
execute "normal a<\<C-r>\<C-c>r>\<Esc>"
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
