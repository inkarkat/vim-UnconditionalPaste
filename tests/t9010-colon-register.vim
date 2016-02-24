" Test linewise pasting of : register.

call feedkeys(":call Test()\<CR>", 't') " Need feedkeys() here to virtually "type" the command so that it's added to command history.
function! Test()
    normal ":glp
    call VerifyRegister()

    call vimtest#SaveOut()
    call vimtest#Quit()
endfunction
