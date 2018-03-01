call vimtest#AddDependency('vim-ingo-library')

runtime plugin/UnconditionalPaste.vim
if g:runVimTest =~# '-repeat[.-]'
    call vimtest#AddDependency('vim-repeat')
endif

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
    if ! exists('s:reg')
	call vimtap#Plan(2)
    elseif s:reg !=# '"'
	call vimtap#Plan(4)
    else
	call vimtap#Plan(2)
    endif

    if ! exists('s:reg') || s:reg !=# '"'
	call vimtap#Is(getreg('"'), "[default text]\n", 'unnamed register contains original text')
	call vimtap#Is(getregtype('"'), 'V', 'unnamed register contains original yank type')
    endif
    if exists('s:reg')
	call vimtap#Is(getreg(s:reg, 1), s:regContent, 'used register contains original text')
	call vimtap#Is(getregtype(s:reg), s:regType, 'used register contains original yank type')
    endif
endfunction
