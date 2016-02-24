" UnconditionalPaste/Increment.vim: Functions for incrementing pasted numbers.
"
" DEPENDENCIES:
"   - ingo/cursor.vim autoload script
"   - ingo/number.vim autoload script
"
" Copyright: (C) 2014-2015 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   3.20.002	22-Apr-2015	Retire UnconditionalPaste#IsAtEndOfLine() and
"				s:DecimalNumberStringIncrement(), and establish
"				hard dependency on ingo-library.
"   3.00.001	21-Mar-2014	file creation from autoload/UnconditionalPaste.vim

function! s:IncrementLine( line, vcol, replacement )
    if a:vcol == -1 || a:vcol == 0 && ingo#cursor#IsAtEndOfLine()
	" Increment the last number.
	return [-1, substitute(a:line, '\d\+\ze\D*$', a:replacement, '')]
    endif

    let l:text = a:line
    let l:vcol = (a:vcol == 0 ? virtcol('.') : a:vcol)
    if l:vcol > 1
	return [l:vcol, substitute(a:line, '\d*\%>' . (l:vcol - 1) . 'v\d\+', a:replacement, '')]
    else
	return [1, substitute(a:line, '\d\+', a:replacement, '')]
    endif
endfunction
function! UnconditionalPaste#Increment#Single( text, vcol, offset )
    let l:replacement = '\=ingo#number#DecimalStringIncrement(submatch(0),' . a:offset . ')'

    let l:didIncrement = 0
    let l:vcol = 0
    let l:result = []
    for l:line in split(a:text, '\n', 1)
	let [l:vcol, l:incrementedLine] = s:IncrementLine(l:line, a:vcol, l:replacement)
	let l:didIncrement = l:didIncrement || (l:line !=# l:incrementedLine)
	call add(l:result, l:incrementedLine)
    endfor

    if ! l:didIncrement
	" Fall back to incrementing the first number.
	let l:vcol = 0
	let l:result = map(split(a:text, '\n', 1), 'substitute(v:val, "\\d\\+", l:replacement, "")')
    endif

    return [l:vcol, join(l:result, "\n")]
endfunction
function! UnconditionalPaste#Increment#Global( text, vcol, offset )
    let l:replacement = '\=ingo#number#DecimalStringIncrement(submatch(0),' . a:offset . ')'
    return [0, substitute(a:text, '\d\+', l:replacement, 'g')]
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
