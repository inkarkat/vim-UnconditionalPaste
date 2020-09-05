" UnconditionalPaste/Separators.vim: Functions for pasting with separators.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2014-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! UnconditionalPaste#Separators#Check( mode, regType, isPasteAfter, separatorPattern, isUseSeparatorWhenAlreadySurrounded )
    if a:mode ==# 'c'
	let [l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter] = s:CommandLineCheck(a:regType, a:separatorPattern)
	return s:DeterminePrefixSuffix(l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter, a:isUseSeparatorWhenAlreadySurrounded)
    elseif a:mode ==# 'i'
	let [l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter] = s:BufferCheck(a:regType, 0, a:separatorPattern)
	return s:DeterminePrefixSuffix(l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter, a:isUseSeparatorWhenAlreadySurrounded)
    else
	let [l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter] = s:BufferCheck(a:regType, a:isPasteAfter, a:separatorPattern)
	return s:DeterminePrefixSuffix(l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter, a:isUseSeparatorWhenAlreadySurrounded, a:isPasteAfter)
    endif
endfunction
function! s:CommandLineCheck( regType, separatorPattern )
    if a:regType ==# 'V'
	return [0, 0, 0, 0]   " There are no surrounding lines in command-line mode; assume we want the prefix / suffix.
    else
	let [l:beforeText, l:afterText] = [strpart(getcmdline(), 0, getcmdpos() - 1), strpart(getcmdline(), getcmdpos() - 1)]
	let [l:isAtStart, l:isAtEnd] = [empty(l:beforeText), empty(l:afterText)]

	let l:isBefore = (l:beforeText =~# s:GetSeparatorPattern(a:separatorPattern, 0) . '$')
	let l:isAfter  = (l:afterText  =~# '^' . s:GetSeparatorPattern(a:separatorPattern, 1))

	return [l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter]
    endif
endfunction
function! s:IsEmpty( lnum, ...) abort
    let l:emptyLinePattern = ingo#plugin#setting#GetBufferLocal('UnconditionalPaste_EmptyLinePattern')

    if type(l:emptyLinePattern) != type([])
	return (getline(a:lnum) =~# l:emptyLinePattern)
    endif

    if a:0
	return (getline(a:lnum) =~# l:emptyLinePattern[a:1])
    else
	" No above / below is specified; if any of the patterns matches, assume
	" empty.
	return (
	\   getline(a:lnum) =~# l:emptyLinePattern[0] ||
	\   getline(a:lnum) =~# l:emptyLinePattern[1]
	\)
    endif
endfunction
function! s:GetSeparatorPattern( separatorPattern, isAfter ) abort
    return (type(a:separatorPattern) != type([]) ?
    \   a:separatorPattern :
    \   a:separatorPattern[a:isAfter]
    \)
endfunction
function! s:BufferCheck( regType, isPasteAfter, separatorPattern )
    if a:regType ==# 'V'
	let [l:startLnum, l:endLnum] = [ingo#range#NetStart(), ingo#range#NetEnd()]
	let l:isEmptyBuffer = (line('$') == 1 && s:IsEmpty(l:startLnum))
	let l:isAtStart = ((! a:isPasteAfter && l:startLnum == 1) || l:isEmptyBuffer)
	let l:isAtEnd = ((a:isPasteAfter && l:endLnum == line('$')) || l:isEmptyBuffer)

	let l:isPrevious = (! l:isAtStart && s:IsEmpty(l:startLnum - 1, a:isPasteAfter))
	let l:isNext = (! l:isAtEnd && s:IsEmpty(l:endLnum + 1, a:isPasteAfter))

	let l:isBefore = (a:isPasteAfter ? s:IsEmpty(l:endLnum, 0) : l:isPrevious)
	let l:isAfter = (a:isPasteAfter ? l:isNext : s:IsEmpty(l:startLnum, 1))
    else
	let l:isAtStart = (col('.') == 1)
	let l:isAtEnd = ingo#cursor#IsAtEndOfLine()

	if l:isAtStart && l:isAtEnd && ! s:IsEmpty('.')
	    " When the current line is completely empty, add both prefix and
	    " suffix. But when the current line contains a single character (so
	    " we're also both at start and end simultaneously), only add the
	    " separator on the side we're pasting to.
	    execute 'let l:isAt' . (a:isPasteAfter ? 'Start' : 'End') . ' = 0'
	endif

	let l:isBefore = search(
	\   (a:isPasteAfter ?
	\       '\%#' . s:GetSeparatorPattern(a:separatorPattern, 0) :
	\       s:GetSeparatorPattern(a:separatorPattern, 0) . '\%#'
	\   ),
	\   'bcnW',
	\   line('.')
	\)
	let l:isAfter = search(
	\   (a:isPasteAfter ?
	\       '\%#.' . s:GetSeparatorPattern(a:separatorPattern, 1) :
	\       '\%#' . s:GetSeparatorPattern(a:separatorPattern, 1)
	\   ),
	\   'cnW',
	\   line('.')
	\)
    endif

    return [l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter]
endfunction
function! s:DeterminePrefixSuffix( isAtStart, isAtEnd, isBefore, isAfter, isUseSeparatorWhenAlreadySurrounded, ...)
    let l:isPasteBefore = (a:0 ? ! a:1 : 1)
    let l:isPasteAfter = (a:0 ? a:1 : 1)
    let l:isPrefix = ! (l:isPasteBefore && a:isAtStart && ! a:isAtEnd || a:isBefore && (! a:isAfter || ! a:isUseSeparatorWhenAlreadySurrounded))
    let l:isSuffix = ! (l:isPasteAfter  && a:isAtEnd && ! a:isAtStart || a:isAfter && (! a:isBefore || ! a:isUseSeparatorWhenAlreadySurrounded))

    return [l:isPrefix, l:isSuffix]
endfunction
function! UnconditionalPaste#Separators#SpecialPasteLines( content, pasteAfterExpr, newLineIndent )
    let l:lnum = line('.')
    let l:additionalLineCnt = 0
    for l:text in a:content
	if l:lnum > line('$')
	    let l:line = ''
	    let l:col = 0

	    let l:text = a:newLineIndent . l:text
	    let l:additionalLineCnt += 1
	else
	    let l:line = getline(l:lnum)
	    let l:col = match(l:line, a:pasteAfterExpr)
	endif

	call ingo#text#Insert([l:lnum, l:col + 1], l:text)
	let l:lnum += 1
    endfor

    if l:additionalLineCnt > 0 && l:additionalLineCnt > &report
	echomsg printf('%d more line%s', l:additionalLineCnt, (l:additionalLineCnt == 1 ? '' : 's'))
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
