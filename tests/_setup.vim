runtime plugin/UnconditionalPaste.vim

call setreg('"', "[default text]\n", 'V')

call setline(1, '1 padding text')
call setline(2, '2 padding text')
call setline(3, 'we (|) here')
call setline(4, '4 padding text')
call setline(5, '5 padding text')
call cursor(3, 5)

let s:foo = 0
function! Foo()
    let s:foo += 1
    return s:foo
endfunction

function! SetRegister( register, contents, type )
    let [s:reg, s:regContent, s:regType] = [a:register, a:contents, a:type]
    call setreg(a:register, a:contents, a:type)
endfunction
function! VerifyRegister()
    call vimtest#StartTap()
    if s:reg !=# '"'
	call vimtap#Plan(4)
	call vimtap#Is(getreg('"'), "[default text]\n", 'unnamed register contains original text')
	call vimtap#Is(getregtype('"'), 'V', 'unnamed register contains original yank type')
    else
	call vimtap#Plan(2)
    endif

    call vimtap#Is(getreg(s:reg), s:regContent, 'used register contains original text')
    call vimtap#Is(getregtype(s:reg), s:regType, 'used register contains original yank type')
endfunction
