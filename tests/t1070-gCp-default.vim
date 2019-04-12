" Test gCp of multiple lines in default register.

call SetRegister('"', "\t    \n\nf  o o \n\n\tb\ta   r   \n\n  b \t \t z \t \n\n\n", 'V')
normal gCp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
