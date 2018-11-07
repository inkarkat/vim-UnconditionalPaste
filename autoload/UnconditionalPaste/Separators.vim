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
"
" REVISION	DATE		REMARKS
"   3.20.003	22-Apr-2015	Retire UnconditionalPaste#IsAtEndOfLine() and
"				establish hard dependency on ingo-library.
"   3.03.002	24-Nov-2014	BUG: gsp / gsP border check adds spaces on both
"				sides when there's a single character in line
"				(like when there's a completely empty line,
"				where this would be correct). Differentiate
"				between empty and single-char line and then
"				clear the isAtStart / isAtEnd flag not in the
"				direction of the paste.
"   3.00.001	21-Mar-2014	file creation from autoload/UnconditionalPaste.vim

function! UnconditionalPaste#Separators#Check( regType, isPasteAfter, separatorPattern, isUseSeparatorWhenAlreadySurrounded )
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
    let l:isPrefix = ! (! a:isPasteAfter && l:isAtStart && ! l:isAtEnd || l:isBefore && (! l:isAfter || ! a:isUseSeparatorWhenAlreadySurrounded))
    let l:isSuffix = ! (  a:isPasteAfter && l:isAtEnd && ! l:isAtStart || l:isAfter && (! l:isBefore || ! a:isUseSeparatorWhenAlreadySurrounded))

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
