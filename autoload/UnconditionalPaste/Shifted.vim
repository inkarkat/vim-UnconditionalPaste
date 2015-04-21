" UnconditionalPaste/Shifted.vim: Functions for pasting with shiftwidth.
"
" DEPENDENCIES:
"   - ingo/compat/strdisplaywidth.vim autoload script (only if Vim doesn't have
"     strdisplaywidth())
"   - AlignFromCursor.vim autoload script (optional)
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   3.00.001	21-Mar-2014	file creation from autoload/UnconditionalPaste.vim

if exists('*strdisplaywidth')
    function! s:strdisplaywidth( expr, ... )
	return call('strdisplaywidth', [a:expr] + a:000)
    endfunction
else
    function! s:strdisplaywidth( expr, ... )
	return call('ingo#compat#strdisplaywidth', [a:expr] + a:000)
    endfunction
endif

silent! call AlignFromCursor#DoesNotExist()	" Execute a function to force autoload.
if ! g:UnconditionalPaste_IsFullLineRetabOnShift && exists('*AlignFromCursor#GetRetabbedFromCol')
    function! s:SetAndRetab( lnum, line, col )
	call setline(a:lnum, AlignFromCursor#GetRetabbedFromCol(a:line, a:col))
    endfunction
else
    function! s:SetAndRetab( lnum, line, col )
	call setline(a:lnum, a:line)
	silent execute a:lnum . 'retab!'
    endfunction
endif


function! UnconditionalPaste#Shifted#SpecialShiftedPrepend( content, count )
    let l:contentWidths = map(copy(a:content), 's:strdisplaywidth(v:val)')
    let l:maxContentWidth = max(l:contentWidths)
    let l:targetWidth = l:maxContentWidth + a:count * &l:shiftwidth - (l:maxContentWidth % &l:shiftwidth)

    let l:lnum = line('.')
    let l:additionalLineCnt = 0

    for l:text in a:content
	let l:textWidth = remove(l:contentWidths, 0)
	if l:lnum > line('$')
	    let l:line = ''
	    let l:additionalLineCnt += 1
	else
	    let l:line = getline(l:lnum)
	endif

	if empty(l:line)
	    call setline(l:lnum, l:text)    " Skip indenting when pasting to an empty line.
	else
	    let l:indentWidth = l:targetWidth - l:textWidth

	    " In order to properly render the contained Tab characters of the
	    " original line, they need to be first expanded to spaces.
	    let l:expandedLine = substitute(l:line, '^\t\+', '\=substitute(submatch(0), "\\t", repeat(" ", &l:tabstop), "g")', '')

	    let l:newLine = l:text . repeat(' ', l:indentWidth) . l:expandedLine
	    call s:SetAndRetab(l:lnum, l:newLine, len(l:text) + 1)
	endif
	let l:lnum += 1
    endfor

    if l:additionalLineCnt > 0 && l:additionalLineCnt > &report
	echomsg printf('%d more line%s', l:additionalLineCnt, (l:additionalLineCnt == 1 ? '' : 's'))
    endif
endfunction
function! UnconditionalPaste#Shifted#SpecialShiftedAppend( content, count )
    let l:lnum = line('.')
    let l:baseScreenWidth = s:strdisplaywidth(getline(l:lnum))
    let l:baseTargetWidth = l:baseScreenWidth + a:count * &l:shiftwidth - (l:baseScreenWidth % &l:shiftwidth)

    let l:additionalLineCnt = 0

    for l:text in a:content
	if l:lnum > line('$')
	    let l:line = ''
	    let l:currentScreenWidth = 0

	    let l:additionalLineCnt += 1
	else
	    let l:line = getline(l:lnum)
	    let l:currentScreenWidth = s:strdisplaywidth(getline(l:lnum))
	endif

	if empty(l:text)
	    call setline(l:lnum, l:line)    " Skip indenting when pasting an empty line.
	else
	    if l:currentScreenWidth < l:baseTargetWidth
		let l:indentWidth = l:baseTargetWidth - l:currentScreenWidth
	    else
		" This line is longer than the targeted width of the first
		" line's indent; add another indent to it.
		let l:indentWidth = &l:shiftwidth - (l:currentScreenWidth % &l:shiftwidth)
	    endif

	    let l:newLine = l:line . repeat(' ', l:indentWidth) . l:text
	    call s:SetAndRetab(l:lnum, l:newLine, len(l:line) + 1)
	endif
	let l:lnum += 1
    endfor

    if l:additionalLineCnt > 0 && l:additionalLineCnt > &report
	echomsg printf('%d more line%s', l:additionalLineCnt, (l:additionalLineCnt == 1 ? '' : 's'))
    endif
endfunction


" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
