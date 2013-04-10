" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of
" how it was yanked.
"
" DEPENDENCIES:

" Copyright: (C) 2006-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory,
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
"
" REVISION	DATE		REMARKS
"   2.20.021	18-Mar-2013	ENH: Add gPp / gPP mappings to paste with all
"				numbers incremented / decremented.
"   2.20.020	15-Mar-2013	ENH: gpp also handles multi-line pastes. A
"				number (after the corresponding column) is
"				incremented in every line. If there are no
"				increments this way, fall back to replacement of
"				the first occurrence.
"   2.10.019	21-Dec-2012	FIX: For characterwise pastes with a [count],
"				the multiplied pastes must be joined with the
"				desired separator, not just plainly
"				concatenated.
"				ENH: Add mappings to paste with one number
"				(which depending on the current cursor position)
"				incremented / decremented.
"				Handle repeat of gpp with the last used offset
"				and the same number position by introducing a
"				special ".p" paste type.
"				FIX: Don't lose the original [count] given when
"				repeating the mapping. As
"				UnconditionalPaste#Paste() executes a normal
"				mode command, we need to store v:count and make
"				it available to the <Plug>-mapping via the new
"				UnconditionalPaste#GetCount() getter.
"   2.00.018	07-Dec-2012	FIX: Differentiate between pasteType and a:how
"				argument, as setregtype() only understands the
"				former.
"   2.00.017	06-Dec-2012	CHG: Flatten all whitespace and newlines before,
"				after, and around lines when pasting
"				characterwise or joined.
"   2.00.016	05-Dec-2012	ENH: Add mappings to insert register contents
"				characterwise (flattened) from insert mode.
"				ENH: Add mappings to paste lines flattened with
"				comma, queried, or recalled last used delimiter.
"				ENH: Add mappings to paste unjoined register
"				with queried or recalled last used delimiter
"				pattern.
"   1.22.015	04-Dec-2012	Split off functions into autoload script.
"   1.22.014	28-Nov-2012	BUG: When repeat.vim is not installed, the
"				mappings do nothing. Need to :execute the
"				:silent! call of repeat.vim to avoid that the
"				remainder of the command line is aborted
"				together with the call.
"   1.21.013	02-Dec-2011	ENH: When pasting a blockwise register as lines,
"				strip all trailing whitespace. This is useful
"				when cutting a block of text from a column-like
"				text and pasting as new lines.
"				ENH: When pasting a blockwise register as
"				characters, flatten and shrink all trailing
"				whitespace to a single space.
"   1.20.012	29-Sep-2011	BUG: Repeat always used the unnamed register.
"				Add register registration to enhanced repeat.vim
"				plugin, which also handles repetition when used
"				together with the expression register "=.
"				BUG: Move <silent> maparg to <Plug> mapping to
"				silence command repeat.
"   1.11.010	06-Jun-2011	ENH: Support repetition of mappings through
"				repeat.vim.
"   1.10.009	12-Jan-2011	Incorporated suggestions by Peter Rincker
"				(thanks for the patch!):
"				Made mappings configurable via the customary
"				<Plug> mappings.
"				Added mappings gbp, gbP for blockwise pasting.
"				Now requires Vim version 7.0 or higher.
"   1.00.008	10-Dec-2010	Prepared for publishing; find out lowest
"				supported Vim version.
"	007	15-May-2009	Now catching and reporting any errors caused by
"				the paste.
"				Now supporting [count], like the built-in paste
"				command.
"	006	08-Oct-2008	Now removing newline characters at the end of
"				the text.
"				Now, the register type is not modified by an
"				unconditional paste command.
"				Now, multiple sequential newlines are converted
"				to a single space.
"				Refactored s:FlattenRegister() to s:Flatten().
"	005	16-Jun-2008	Using :normal with <bang>.
"	004	30-May-2007	Added <silent> to the mapping to avoid echoing
"				of the function invocation.
"	0.03	13-May-2006	Changed mappings from <leader>.. to g.., as
"				this is easier to type (and 'g' often introduces
"				alternative actions (like 'j' and 'gj')).
"	0.02	10-Apr-2006	Added flattening (replacing newlines with
"				spaces) for characterwise paste.
"	0.01	10-Apr-2006	file creation from vimtip #1199

function! UnconditionalPaste#HandleExprReg( exprResult )
    let s:exprResult = a:exprResult
endfunction

function! s:Flatten( text, separator )
    " Remove newlines and whitespace at the begin and end of the text, convert
    " all other newlines (plus leading and trailing whitespace) to the passed
    " separator.
    return substitute(substitute(a:text, '^\s*\%(\n\s*\)*\|\s*\%(\n\s*\)*$', '', 'g'), '\s*\%(\n\s*\)\+', a:separator, 'g')
endfunction
function! s:StripTrailingWhitespace( text )
    return substitute(a:text, '\s\+\ze\(\n\|$\)', '', 'g')
endfunction
function! s:Unjoin( text, separatorPattern )
    let l:text = substitute(a:text, a:separatorPattern, '\n', 'g')

    " A (single!) trailing separator is automatically swallowed by the linewise
    " pasting. For consistency, do the same for a single leading separator.
    return (l:text =~# '^\n' ? l:text[1:] : l:text)
endfunction
function! s:IncrementLine( line, vcol, replacement )
    if a:vcol == -1 || a:vcol == 0 && col('.') + 1 == col('$')
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
function! s:SingleIncrement( text, vcol, offset )
    let l:replacement = '\=submatch(0) + ' . a:offset

    let l:didIncrement = 0
    let l:vcol = 0
    let l:result = []
    for l:line in split(a:text, "\n", 1)
	let [l:vcol, l:incrementedLine] = s:IncrementLine(l:line, a:vcol, l:replacement)
	let l:didIncrement = l:didIncrement || (l:line !=# l:incrementedLine)
	call add(l:result, l:incrementedLine)
    endfor

    if ! l:didIncrement
	" Fall back to incrementing the first number.
	let l:vcol = 0
	let l:result = map(split(a:text, "\n", 1), 'substitute(v:val, "\\d\\+", l:replacement, "")')
    endif

    return [l:vcol, join(l:result, "\n")]
endfunction
function! s:GlobalIncrement( text, vcol, offset )
    let l:replacement = '\=submatch(0) + ' . a:offset
    return [0, substitute(a:text, '\d\+', l:replacement, 'g')]
endfunction

function! UnconditionalPaste#GetCount()
    return s:count
endfunction
function! UnconditionalPaste#Paste( regName, how, ... )
    let l:count = v:count
    let s:count = v:count
    let l:regType = getregtype(a:regName)
    let l:regContent = getreg(a:regName, 1) " Expression evaluation inside function context may cause errors, therefore get unevaluated expression when a:regName ==# '='.

    if a:regName ==# '='
	" Cannot evaluate the expression register within a function; unscoped
	" variables do not refer to the global scope. Therefore, evaluation
	" happened earlier in the mappings, and stored this in s:exprResult.
	" To get the expression result into the buffer, use the unnamed
	" register, and restore it later.
	let l:regName = '"'
	let l:regContent = s:exprResult

	let l:save_clipboard = &clipboard
	set clipboard= " Avoid clobbering the selection and clipboard registers.
	let l:save_reg = getreg(l:regName)
	let l:save_regmode = getregtype(l:regName)
    else
	let l:regName = a:regName
    endif

    try
	let l:pasteContent = l:regContent
	let l:pasteType = 'l'

	if a:how ==# 'b'
	    let l:pasteType = 'b'
	elseif a:how =~# '^[c,qQ]$'
	    let l:pasteType = 'c'

	    if l:regType[0] ==# "\<C-v>"
		let l:pasteContent = s:StripTrailingWhitespace(l:regContent)
	    else
		let l:pasteContent = l:regContent
	    endif

	    if a:how ==# 'c'
		let l:separator = ' '
	    elseif a:how ==# ','
		let l:separator = ', '
	    elseif a:how ==# 'q'
		let l:separator = input('Enter separator string: ')
		if empty(l:separator)
		    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		    return ''
		endif
		let g:UnconditionalPaste_JoinSeparator = l:separator
	    elseif a:how ==# 'Q'
		let l:separator = g:UnconditionalPaste_JoinSeparator
	    else
		throw 'ASSERT: Invalid how: ' . string(a:how)
	    endif

	    if l:count > 1
		" To join the multiplied pastes with the desired separator, we
		" need to process the multiplication on our own.
		let l:pasteContent = repeat(l:pasteContent . "\n", l:count)
		let l:count = 0
	    endif

	    let l:pasteContent = s:Flatten(l:pasteContent, l:separator)
	elseif a:how ==? 'u'
	    if a:how ==# 'u'
		let l:separatorPattern = input('Enter separator pattern: ')
		if empty(l:separatorPattern)
		    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		    return ''
		endif
		let g:UnconditionalPaste_UnjoinSeparatorPattern = l:separatorPattern
	    endif

	    let l:pasteContent = s:Unjoin(l:pasteContent, g:UnconditionalPaste_UnjoinSeparatorPattern)
	    if l:pasteContent ==# l:regContent
		" No unjoining took place; this is probably not what the user
		" intended (maybe wrong register?), so don't just insert the
		" contents unchanged, but rather alert the user.
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return ''
	    endif
	elseif a:how ==# 'l' && l:regType[0] ==# "\<C-v>"
	    let l:pasteContent = s:StripTrailingWhitespace(l:regContent)
	elseif a:how ==? 'p' || a:how ==? '.p'
	    let l:pasteType = l:regType " Keep the original paste type.
	    let l:offset = (a:1 ==# 'p' ? 1 : -1)
	    if a:how ==? 'p'
		let l:baseCount = 1
		let l:vcol = 0
	    elseif a:how ==? '.p'
		" Continue increasing with the last used (saved) offset, and
		" (for 'p') at the same number position (after the first paste,
		" the cursor will have jumped to the beginning of the pasted
		" text).
		let l:baseCount = s:lastCount + 1
		let l:vcol = s:lastVcol
	    else
		throw 'ASSERT: Invalid how: ' . string(a:how)
	    endif
	    let s:lastCount = l:baseCount

	    let l:IncrementFunc = (a:how ==# 'p' || a:how ==# '.p' ? 's:SingleIncrement' : 's:GlobalIncrement')
	    let [s:lastVcol, l:pasteContent] = call(l:IncrementFunc, [l:regContent, l:vcol, l:offset * l:baseCount])
	    if l:pasteContent ==# l:regContent
		" No number was found in the register; this is probably not what
		" the user intended (maybe wrong register?), so don't just
		" insert the contents unchanged, but rather alert the user.
		execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
		return ''
	    endif

	    if l:count > 1
		" To increment each multiplied paste one more, we need to
		" process the multiplication on our own.
		let l:numbers = (l:offset > 0 ? range(l:baseCount, l:baseCount + l:count - 1) : range(-1 * (l:baseCount + l:count - 1), -1 * l:baseCount))
		let l:pasteContent = join(map(l:numbers, l:IncrementFunc . '(l:regContent, l:vcol, v:val)[1]'), (l:regType[0] ==# "\<C-v>" ? "\n" : ''))
		let s:lastCount = l:baseCount + l:count - 1
		let l:count = 0
	    endif
	endif

	if a:0
	    call setreg(l:regName, l:pasteContent, l:pasteType)
		execute 'normal! "' . l:regName . (l:count ? l:count : '') . a:1
	    call setreg(l:regName, l:regContent, l:regType)
	else
	    return l:pasteContent
	endif
    catch /^Vim\%((\a\+)\)\=:E/
	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away.
	let v:errmsg = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    finally
	if a:regName ==# '='
	    call setreg('"', l:save_reg, l:save_regmode)
	    let &clipboard = l:save_clipboard
	endif
    endtry
endfunction
function! UnconditionalPaste#Insert( regName, how )
    if a:regName !~? '[0-9a-z"%#*+:.-]'
	" Note the lack of "="; we don't support the expression register here,
	" because we would need to do the querying and evaluation all by
	" ourselves.
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	return ''
    endif

    return UnconditionalPaste#Paste(a:regName, a:how)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
