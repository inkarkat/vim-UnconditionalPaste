" Test linewise pasting of . register.

execute "normal! a[foo]\<Esc>"
normal ".glp
call VerifyRegister()

call vimtest#SaveOut()
call vimtest#Quit()
