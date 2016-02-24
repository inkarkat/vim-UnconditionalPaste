" Test gup of three words in default register.

call SetRegister('"', "This Is Foo", 'v')
normal gup
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
