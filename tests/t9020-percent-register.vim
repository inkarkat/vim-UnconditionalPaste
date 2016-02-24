" Test linewise pasting of % register.

file foo.txt
normal "%glp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
