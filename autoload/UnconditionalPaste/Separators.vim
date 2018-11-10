" UnconditionalPaste/Separators.vim: Functions for pasting with separators.
"
" DEPENDENCIES:
"   - ingo/cursor.vim autoload script
"   - ingo/text.vim autoload script
"
" Copyright: (C) 2014-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

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

	let l:isBefore = (l:beforeText =~# a:separatorPattern . '$')
	let l:isAfter  = (l:afterText  =~# '^' . a:separatorPattern)

	return [l:isAtStart, l:isAtEnd, l:isBefore, l:isAfter]
    endif
endfunction
function! s:BufferCheck( regType, isPasteAfter, separatorPattern )
    if a:regType ==# 'V'
	let l:isAtStart = (line('.') == 1)
	let l:isAtEnd = (line('.') == line('$'))

	let l:isPrevious = (line('.') > 1 && empty(getline(line('.') - 1)))
	let l:isCurrent = empty(getline('.'))
	let l:isNext = (line('.') < line('$') && empty(getline(line('.') + 1)))

	let l:isBefore = (a:isPasteAfter ? l:isCurrent : l:isPrevious)
	let l:isAfter = (a:isPasteAfter ? l:isNext : l:isCurrent)
    else
	let l:isAtStart = (col('.') == 1)
	let l:isAtEnd = ingo#cursor#IsAtEndOfLine()

	if l:isAtStart && l:isAtEnd && ! empty(getline('.'))
	    " When the current line is completely empty, add both prefix and
	    " suffix. But when the current line contains a single character (so
	    " we're also both at start and end simultaneously), only add the
	    " separator on the side we're pasting to.
	    execute 'let l:isAt' . (a:isPasteAfter ? 'Start' : 'End') . ' = 0'
	endif

	let l:isBefore = search((a:isPasteAfter ? '\%#' . a:separatorPattern : a:separatorPattern . '\%#'), 'bcnW', line('.'))
	let l:isAfter = search((a:isPasteAfter ? '\%#.' . a:separatorPattern : '\%#' . a:separatorPattern), 'cnW', line('.'))
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

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
