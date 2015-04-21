" UnconditionalPaste/Separators.vim: Functions for pasting with separators.
"
" DEPENDENCIES:
"   - UnconditionalPaste.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   3.03.002	24-Nov-2014	BUG: gsp / gsP border check adds spaces on both
"				sides when there's a single character in line
"				(like when there's a completely empty line,
"				where this would be correct). Differentiate
"				between empty and single-char line and then
"				clear the isAtStart / isAtEnd flag not in the
"				direction of the paste.
"   3.00.001	21-Mar-2014	file creation from autoload/UnconditionalPaste.vim

function! UnconditionalPaste#Separators#Check( regType, pasteCommand, separatorPattern, isUseSeparatorWhenAlreadySurrounded )
    if a:regType ==# 'V'
	let l:isAtStart = (line('.') == 1)
	let l:isAtEnd = (line('.') == line('$'))

	let l:isPrevious = (line('.') > 1 && empty(getline(line('.') - 1)))
	let l:isCurrent = empty(getline('.'))
	let l:isNext = (line('.') < line('$') && empty(getline(line('.') + 1)))

	let l:isBefore = (a:pasteCommand ==# 'P' ? l:isPrevious : l:isCurrent)
	let l:isAfter = (a:pasteCommand ==# 'P' ? l:isCurrent : l:isNext)
    else
	let l:isAtStart = (col('.') == 1)
	let l:isAtEnd = UnconditionalPaste#IsAtEndOfLine()

	if l:isAtStart && l:isAtEnd && ! empty(getline('.'))
	    " When the current line is completely empty, add both prefix and
	    " suffix. But when the current line contains a single character (so
	    " we're also both at start and end simultaneously), only add the
	    " separator on the side we're pasting to.
	    execute 'let l:isAt' . (a:pasteCommand ==# 'P' ? 'End' : 'Start') . ' = 0'
	endif

	let l:isBefore = search((a:pasteCommand ==# 'P' ? a:separatorPattern . '\%#' : '\%#' . a:separatorPattern), 'bcnW', line('.'))
	let l:isAfter = search((a:pasteCommand ==# 'P' ? '\%#' . a:separatorPattern : '\%#.' . a:separatorPattern), 'cnW', line('.'))
    endif
    let l:isPrefix = ! (a:pasteCommand ==# 'P' && l:isAtStart && ! l:isAtEnd || l:isBefore && (! l:isAfter || ! a:isUseSeparatorWhenAlreadySurrounded))
    let l:isSuffix = ! (a:pasteCommand ==# 'p' && l:isAtEnd && ! l:isAtStart || l:isAfter && (! l:isBefore || ! a:isUseSeparatorWhenAlreadySurrounded))

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

	" Note: Could use ingo#text#Insert(), but avoid dependency to
	" ingo-library for now.
	"call ingo#text#Insert([l:lnum, l:col + 1], l:text)
	call setline(l:lnum, strpart(l:line, 0, l:col) . l:text . strpart(l:line, l:col))
	let l:lnum += 1
    endfor

    if l:additionalLineCnt > 0 && l:additionalLineCnt > &report
	echomsg printf('%d more line%s', l:additionalLineCnt, (l:additionalLineCnt == 1 ? '' : 's'))
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
