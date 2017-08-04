" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of
" how it was yanked.
"
" DEPENDENCIES:
"   - UnconditionalPaste/Increment.vim autoload script
"   - UnconditionalPaste/Separators.vim autoload script
"   - UnconditionalPaste/Shifted.vim autoload script
"   - ingo/cmdargs.vim autoload script
"   - ingo/cmdline/showmode.vim autoload script
"   - ingo/collections.vim autoload script
"   - ingo/cursor.vim autoload script
"   - ingo/dict.vim autoload script
"   - ingo/err.vim autoload script
"   - ingo/format/columns.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/query.vim autoload script
"   - ingo/query/get.vim autoload script
"   - ingo/str.vim autoload script

" Copyright: (C) 2006-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory,
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
"
" REVISION	DATE		REMARKS
"   4.20.043	30-Dec-2016	Add s:FlattenLastDifferently() variant of
"				s:Flatten() to implement CommaAnd (g,ap),
"				CommaOr (g,op), and CommaNor (g,np) variants of
"				g,p
"   4.20.042	24-Dec-2016	Add s:JustJoin() variant of s:Flatten() to
"				implement JustJoined (gcgp) and QueriedJoined
"				(gqgp, <C-q><C-g>) variants of gcp and gqp that
"				keep indent and surrounding whitespace as-is.
"   4.10.041	27-Sep-2016	ENH: Make gqp also support 5-element
"				{prefix}^M{element-prefix}^M{separator}^M{element-suffix}^M{suffix}
"				in addition to the 3-element one.
"   4.10.040	11-Aug-2016	Change default of l:how for Expression pastes
"				from = / == to e / E.
"				ENH: In ghp query, offer help on the mnemonics
"				by pressing ?.
"   4.10.039	10-Aug-2016	Add grp / gr!p / gRp / gR!p mappings that
"				include / exclude lines matching queried /
"				recalled pattern.
"				Add g=p / g==p mappings that process lines
"				through a queried / recalled Vim expression.
"   4.00.038	28-Jan-2016	Pass shiftCommand and shiftCount through
"				s:ApplyAlgorithm() and implement delta
"				calculation (not sure if actually needed).
"				Implement local [count] for individual how
"				combinatorials.
"   4.00.037	27-Jan-2016	Refactoring: Handle all known a:how in
"				s:ApplyAlgorithm(), and assert on invalid one.
"				Don't preset l:pasteType, and use v/V/C-v which
"				are consistent with a:regType, not c/l/b.
"   4.00.036	26-Jan-2016	Need to use temporary default register also for
"				the built-in read-only registers {:%.}.
"				Use ingo-library functions for echoing of
"				potential Vim error (e.g. when unjoining on
"				invalid pattern like ,\().
"				FIX: Vim error on CTRL-R ... mappings
"				incorrectly inserted "0". Need to return '' from
"				:catch.
"				Refactoring: Factor out s:ApplyAlgorithm() from
"				the actual pasting (except for the special case
"				of
"				UnconditionalPaste#Separators#SpecialPasteLines()),
"				as a first step towards allowing multiple
"				transformations.
"   4.00.035	25-Jan-2016	CHG: Reassign gup / gUp mappings to gujp / gUJp.
"   3.20.034	22-Jan-2016	CHG: Split off gSp from gsp; the latter now
"				flattens line(s) like gcp, whereas the new gSp
"				forces linewise surrounding with empty lines.
"				Use ingo#str#Trim(), now that we have a
"				mandatory dependency on ingo-library.
"   3.20.033	15-Jun-2015	Factor out s:QuerySeparatorPattern().
"				ENH: If there's only a single line to paste and
"				no [count] with the blockwise commands (gbp,
"				gBp, gqbq, gQBp), first query about a separator
"				pattern and un-join the register contents.
"   3.20.032	22-Apr-2015	Retire UnconditionalPaste#IsAtEndOfLine() and
"				establish hard dependency on ingo-library.
"				BUG: Escaped characters like \n are handled
"				inconsistently in gqp: resolved as {separator},
"				taken literally in {prefix} and {suffix}. Use
"				ingo#cmdargs#GetUnescapedExpr() to resolve them
"				(also for gqbp, which only supports
"				{separator}). Change s:Flatten() to prevent
"				interpretation of the separator.
"   3.10.031	03-Dec-2014	Add g,'p and g,"p variants of g,p.
"				ENH: Allow to specify prefix and suffix when
"				querying for the separator string in gqp and
"				i_CTRL-R_CTRL-Q.
"   3.02.030	17-Jun-2014	CHG: Change default mappings of gdp and gDp to
"				gqbp and gQBp, respectively.
"   3.01.029	05-May-2014	For gsp, remove surrounding whitespace
"				(characterwise) / empty lines (linewise) before
"				adding the spaces / empty lines. This ensures a
"				more dependable and deterministic DWIM behavior.
"   3.00.028	21-Mar-2014	Add gBp mapping that is a separator-less version
"				of gDp.
"				When pasting additional lines with gBp / gDp,
"				space-indent them to the cursor position, like
"				the default blockwise paste does (but not for
"				the special prepend / append cases).
"				Add g>p mapping to paste shifted register
"				contents.
"				Factor out functions required only by certain
"				paste types into separate autoload scripts.
"				Add g]]p and g[[p mappings to paste like with
"				g]p, but with more / less indent.
"   3.00.027	20-Mar-2014	Avoid gsp inserting spaces / empty lines on a
"				side where there's already whitespace / empty
"				lines (but not when on both sides). This doesn't
"				consider [count], as it would be too difficult
"				to implement.
"				Extract s:CheckSeparators() for reuse by the
"				following mapping.
"				Add gdp / gDp mappings to paste as a minimal
"				fitting block with (queried / recalled)
"				separator string, with special cases at the end
"				of leading indent and at the end of the line.
"   3.00.026	19-Mar-2014	Add g#p mapping to apply 'commentstring' to each
"				indented linewise paste.
"				Add gsp mapping to paste with [count] spaces /
"				empty lines around the register contents.
"   3.00.025	18-Mar-2014	When doing gqp / q,p of a characterwise or
"				single line, put the separator in front (gqp) /
"				after (gqP); otherwise, the mapping is identical
"				to normal p / P and therefore worthless.
"   2.30.024	14-Mar-2014	Make beep in UnconditionalPaste#Insert()
"				configurable; in command-line mode, no beep
"				occurs when an invalid register is specified.
"   2.22.023	14-Jun-2013	Minor: Make substitute() robust against
"				'ignorecase'.
"   2.21.022	11-Apr-2013	FIX: In gpp and gPp, keep leading zeros when
"				incrementing the number.
"				FIX: In gpp and gPp, do not interpret leading
"				zeros as octal numbers when incrementing.
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
let s:save_cpo = &cpo
set cpo&vim

function! UnconditionalPaste#HandleExprReg( exprResult )
    let s:exprResult = a:exprResult
endfunction

function! s:Flatten( text, separator, elementPrefix, elementSuffix )
    " Remove newlines and whitespace at the begin and end of the text.
    let l:text = substitute(a:text, '^\s*\%(\n\s*\)*\|\s*\%(\n\s*\)*$', '', 'g')

    " Split into lines on newlines (plus leading and trailing whitespace).
    let l:lines = split(l:text, '\s*\%(\n\s*\)\+')

    " Add potential prefix and suffix.
    if ! empty(a:elementPrefix . a:elementSuffix)
	call map(l:lines, 'a:elementPrefix . v:val . a:elementSuffix')
    endif

    " Join with passed separator.
    return join(l:lines, a:separator)
endfunction
function! s:FlattenLastDifferently( text, separator, pasteCommand, lastSeparator )
    " Remove newlines and whitespace at the begin and end of the text.
    let l:text = substitute(a:text, '^\s*\%(\n\s*\)*\|\s*\%(\n\s*\)*$', '', 'g')

    " Split into lines on newlines (plus leading and trailing whitespace).
    let l:lines = split(l:text, '\s*\%(\n\s*\)\+')

    " Join with passed separator, using the special a:lastSeparator for the last
    " line.
    let l:allExceptLastLines = l:lines[0:-2]
    if empty(l:allExceptLastLines)
	return (a:pasteCommand ==# 'p' ?
	\   a:lastSeparator . l:lines[-1] :
	\   l:lines[-1] . a:lastSeparator
	\)
    else
	return join(l:allExceptLastLines, a:separator) . a:lastSeparator . l:lines[-1]
    endif
endfunction
function! s:JustJoin( text, separator, elementPrefix, elementSuffix )
    " Split into lines strictly on newlines.
    let l:lines = split(a:text, '\n\+')

    " Add potential prefix and suffix.
    if ! empty(a:elementPrefix . a:elementSuffix)
	call map(l:lines, 'a:elementPrefix . v:val . a:elementSuffix')
    endif

    " Join with passed separator.
    return join(l:lines, a:separator)
endfunction
function! s:StripTrailingWhitespace( text )
    return substitute(a:text, '\s\+\ze\(\n\|$\)', '', 'g')
endfunction
function! s:IsSingleElement( text )
    return a:text !~# '\n.*\%(\n\|\S\)'
endfunction
function! s:Unjoin( text, separatorPattern )
    let l:text = substitute(a:text, a:separatorPattern, '\n', 'g')
    if l:text ==# a:text
	return [0, l:text]
    endif

    " A (single!) trailing separator is automatically swallowed by the linewise
    " pasting. For consistency, do the same for a single leading separator.
    return [1, (l:text =~# '^\n' ? l:text[1:] : l:text)]
endfunction
function! s:QuerySeparatorPattern()
    let l:separatorPattern = input('Enter separator pattern: ')
    if empty(l:separatorPattern)
	return 0
    endif
    let g:UnconditionalPaste_UnjoinSeparatorPattern = l:separatorPattern
    return 1
endfunction
function! s:CompleteEscape( escape )
    if has_key(a:escape, 'Replacer')
	return a:escape
    endif
    if ! has_key(a:escape, 'pattern')
	let a:escape.pattern = '\\'
    endif
    if ! has_key(a:escape, 'replacement')
	let a:escape.replacement = '\\&'
    endif
    return a:escape
endfunction
function! s:SummarizeEscape( escape )
    if has_key(a:escape, 'name')
	return a:escape.name
    elseif has_key(a:escape, 'Replacer')
	return ingo#funcref#ToString(a:escape.Replacer)
    else
	return a:escape.pattern . ' -> ' . a:escape.replacement
    endif
endfunction
function! s:QueryEscape( count )
    let l:escapes = map(copy(ingo#plugin#setting#GetBufferLocal('UnconditionalPaste_Escapes')), 's:CompleteEscape(v:val)')
    if empty(l:escapes)
	let l:escape = s:CompleteEscape({})
	let l:pattern = input('Enter pattern of text to be escaped: ', l:escape.pattern)
	if empty(l:pattern) | return 0 | endif

	let l:replacement = input('Enter replacement of text to be escaped: ', l:escape.replacement)
	if empty(l:replacement) | return 0 | endif

	let l:escape.pattern = l:pattern
	let l:escape.replacement = l:replacement
	let g:UnconditionalPaste_Escape = l:escape
    elseif len(l:escapes) == 1
	let g:UnconditionalPaste_Escape = l:escapes[0]
    elseif a:count > 0
	if a:count > len(l:escapes)
	    return 0
	endif
	let g:UnconditionalPaste_Escape = l:escapes[a:count - 1]
    else
	let l:index = ingo#query#fromlist#Query('escapes', map(copy(l:escapes), 's:SummarizeEscape(v:val)'))
	if l:index == -1
	    return 0
	endif
	let g:UnconditionalPaste_Escape = l:escapes[l:index]
    endif

    return 1
endfunction
function! s:PrintHelp( types, howList )
    let l:typeToName = ingo#dict#FromItems(map(copy(g:UnconditionalPaste_Mappings), '[v:val[1], v:val[0]]'))
    let l:helpItems = map(copy(a:types), 'printf("%2s: %s", v:val, l:typeToName[v:val])')
    for l:helpRow in ingo#format#columns#Distribute(l:helpItems)
	echo join(l:helpRow)
    endfor

    if ! empty(a:howList)
	echo printf('Paste as %s', join(map(copy(a:howList), 'l:typeToName[v:val]'), ' and '))
    endif
endfunction

function! UnconditionalPaste#GetCount()
    return s:count
endfunction
function! s:ApplyAlgorithm( how, regContent, regType, count, shiftCommand, shiftCount, ... )
    let l:pasteContent = a:regContent
    let l:count = a:count
    let l:shiftCommand = a:shiftCommand
    let l:shiftCount = a:shiftCount

    if l:count == 0 && a:how =~# '\c^\%(q\?b\|r!\?\|e\)$' && s:IsSingleElement(a:regContent)
	" Query / re-use separator pattern, and split into multiple lines
	" first.
	if a:how !=# 'QB' && a:how[0] !=# 'R' && a:how !=# 'E'
	    if ! s:QuerySeparatorPattern()
		throw 'beep'
	    endif
	endif

	let [l:isSuccess, l:pasteContent] = s:Unjoin(l:pasteContent, g:UnconditionalPaste_UnjoinSeparatorPattern)
	if ! l:isSuccess
	    " No unjoining took place; this is probably not what the user
	    " intended (maybe wrong register?), so don't just insert the
	    " contents unchanged, but rather alert the user.
	    throw 'beep'
	endif

	" For blockwise pasting, a (single!) trailing separator means an
	" additional empty line in the block; this probably isn't intended.
	if l:pasteContent =~# '\n$' | let l:pasteContent = l:pasteContent[0:-2] | endif
    endif

    if a:how =~# '^[il]$'
	let l:pasteType = 'V'
	if a:regType[0] ==# "\<C-v>"
	    let l:pasteContent = s:StripTrailingWhitespace(a:regContent)
	endif
    elseif a:how ==# 'b'
	let l:pasteType = "\<C-v>"
    elseif a:how =~# '^[c,qQ]g\?$\|^,[''"aon]$'
	let l:pasteType = 'v'
	let l:Joiner = function('s:Flatten')
	let [l:prefix, l:suffix, l:elementPrefix, l:elementSuffix, l:linePrefix, l:lineSuffix] = ['', '', '', '', '', '']

	if a:regType[0] ==# "\<C-v>"
	    let l:pasteContent = s:StripTrailingWhitespace(a:regContent)
	endif

	if a:how ==# 'c'
	    let l:separator = ' '
	elseif a:how ==# 'cg'
	    let l:separator = ''
	    let l:Joiner = function('s:JustJoin')
	elseif a:how[0] ==# ','
	    let l:separator = ', '
	    if a:how[1] =~# '^[aon]$'
		let l:Joiner = function('s:FlattenLastDifferently')
		if a:how[1] ==# 'a'
		    let l:elementSuffix = ' and '
		elseif a:how[1] ==# 'o'
		    let l:elementSuffix = ' or '
		elseif a:how[1] ==# 'n'
		    if ! (a:1 ==# 'p' && l:count == 0 && s:IsSingleElement(a:regContent))
			let l:prefix = 'neither '
		    endif
		    let l:elementSuffix = ' nor '
		else
		    throw 'ASSERT: Unknown comma modifier: ' . string(a:how[1])
		endif
		let l:elementPrefix = a:1
		if g:UnconditionalPaste_IsSerialComma
		    let l:elementSuffix = ',' . l:elementSuffix
		endif
	    elseif ! empty(a:how[1])
		let [l:prefix, l:suffix, l:linePrefix, l:lineSuffix] = repeat([a:how[1:]], 4)
	    endif
	elseif a:how =~# '^qg\?$'
	    if a:how =~# 'g$'
		let l:Joiner = function('s:JustJoin')
	    endif
	    let l:separator = input('Enter separator string (or prefix^Melement-prefix^Mseparator^Melement-suffix^Msuffix or prefix^Mseparator^Msuffix): ')
	    if empty(l:separator)
		throw 'beep'
	    endif

	    unlet! g:UnconditionalPaste_JoinSeparator
	    if l:separator =~# '^\%(\r\@!.\)*\r\%(\r\@!.\)*\r\%(\r\@!.\)*$'
		let [l:prefix, l:separator, l:suffix] = map(split(l:separator, '\r', 1), 'ingo#cmdargs#GetUnescapedExpr(v:val)')
		let g:UnconditionalPaste_JoinSeparator = [l:prefix, l:elementPrefix, l:separator, l:elementSuffix, l:suffix]
	    elseif l:separator =~# '^\%(\r\@!.\)*\r\%(\r\@!.\)*\r\%(\r\@!.\)*\r\%(\r\@!.\)*\r\%(\r\@!.\)*$'
		let g:UnconditionalPaste_JoinSeparator = map(split(l:separator, '\r', 1), 'ingo#cmdargs#GetUnescapedExpr(v:val)')
		let [l:prefix, l:elementPrefix, l:separator, l:elementSuffix, l:suffix] = g:UnconditionalPaste_JoinSeparator
	    else
		let l:separator = ingo#cmdargs#GetUnescapedExpr(l:separator)
		let g:UnconditionalPaste_JoinSeparator = l:separator
	    endif
	elseif a:how =~# '^Qg\?$'
	    if a:how =~# 'g$'
		let l:Joiner = function('s:JustJoin')
	    endif
	    if type(g:UnconditionalPaste_JoinSeparator) == type([])
		let [l:prefix, l:elementPrefix, l:separator, l:elementSuffix, l:suffix] = g:UnconditionalPaste_JoinSeparator
	    else
		let l:separator = g:UnconditionalPaste_JoinSeparator
	    endif
	else
	    throw 'ASSERT: Invalid how: ' . string(a:how)
	endif

	if l:count > 1
	    " To join the multiplied pastes with the desired separator, we
	    " need to process the multiplication on our own.
	    let l:pasteContent = repeat(l:pasteContent . "\n", l:count)
	    let l:count = 0
	endif

	let l:pasteContent = l:prefix . call(l:Joiner, [l:pasteContent, l:linePrefix . l:separator . l:lineSuffix, l:elementPrefix, l:elementSuffix]) . l:suffix

	if a:0 && a:how !~# '^\%(c\|,[aon]\)$' && s:IsSingleElement(a:regContent)
	    " DWIM: Put the separator in front (gqp) / after (gqP);
	    " otherwise, the mapping is identical to normal p / P and
	    " therefore worthless. Do not do this for plain gcp / gcP, as
	    " I often use that mapping to avoid the special handling of
	    " smartput.vim, and this embellishment would counter that.
	    " For that case, better use gsp.
	    if a:1 ==# 'p'
		let l:pasteContent = l:separator . l:pasteContent
	    elseif a:1 ==# 'P'
		let l:pasteContent .= l:separator
	    else
		throw 'ASSERT: Unknown paste command: ' . string(a:1)
	    endif
	endif
    elseif a:how ==? 'uj'
	if a:how ==# 'uj'
	    if ! s:QuerySeparatorPattern()
		throw 'beep'
	    endif
	endif

	let l:pasteType = 'V'
	let [l:isSuccess, l:pasteContent] = s:Unjoin(l:pasteContent, g:UnconditionalPaste_UnjoinSeparatorPattern)
	if ! l:isSuccess
	    " No unjoining took place; this is probably not what the user
	    " intended (maybe wrong register?), so don't just insert the
	    " contents unchanged, but rather alert the user.
	    throw 'beep'
	endif
    elseif a:how =~# '^[mn]$'
	let l:pasteType = 'V'
	let l:shiftAmount = max([l:count, 1])
	let l:shiftCommand = (a:how ==# 'm' ? '>' : '<')
	if empty(a:shiftCommand) || a:shiftCommand ==# l:shiftCommand
	    let l:shiftCount += l:shiftAmount
	else
	    " Now shifting in the other direction.
	    if a:shiftCount == l:shiftCount
		let [l:shiftCommand, l:shiftCount] = ['', 0]
	    elseif a:shiftCount > l:shiftCount
		let [l:shiftCommand, l:shiftCount] = [a:shiftCommand, a:shiftCount - l:shiftCount]
	    else
		let l:shiftCount -= a:shiftCount
	    endif
	endif
	let l:count = 0

	if a:regType[0] ==# "\<C-v>"
	    let l:pasteContent = s:StripTrailingWhitespace(a:regContent)
	endif
    elseif a:how ==# '>'
	let l:pasteType = 'V'
	let l:shiftCount = max([l:count, 1])
	let l:count = 0
	if a:regType ==# 'V'
	    let l:shiftCommand = '>'
	else
	    if a:regType ==# 'v'
		let l:lines = [s:Flatten(l:pasteContent, ' ', '', '')]
	    else
		let l:lines = split(l:pasteContent, '\n', 1)
	    endif

	    if a:1 ==# 'P'
		call UnconditionalPaste#Shifted#SpecialShiftedPrepend(l:lines, l:shiftCount)
	    else
		call UnconditionalPaste#Shifted#SpecialShiftedAppend(l:lines, l:shiftCount)
	    endif
	    return ['', '', 0, '', 0]
	endif
    elseif a:how ==# '#'
	if empty(&commentstring)
	    throw 'beep'
	endif

	let l:pasteType = 'V'
	let l:pasteContent =
	    \	join(
	    \	    map(
	    \		split(l:pasteContent, '\n', 1),
	    \		'empty(v:val) ? "" : printf(&commentstring, v:val)'
	    \	    ),
	    \	    "\n"
	    \	)
    elseif a:how ==# 's'
	let [l:isPrefix, l:isSuffix] = UnconditionalPaste#Separators#Check('v', a:1, '\s', 1)
	let l:prefix = (l:isPrefix ? repeat(' ', max([l:count, 1])) : '')
	let l:suffix = (l:isSuffix ? repeat(' ', max([l:count, 1])) : '')
	let l:count = 0

	if a:regType ==# 'v'
	    let l:pasteType = a:regType " Keep the original paste type.
	    let l:pasteContent = l:prefix . ingo#str#Trim(a:regContent) . l:suffix
	elseif a:regType ==# 'V'
	    let l:pasteType = 'v'
	    let l:pasteContent = l:prefix . ingo#str#Trim(a:regContent) . l:suffix
	    let l:pasteContent = l:prefix . s:Flatten(a:regContent, ' ', '', '') . l:suffix
	else
	    let l:pasteType = a:regType " Keep the original paste type.
	    let l:pasteContent = join(map(split(a:regContent, '\n', 1), 'l:prefix . v:val . l:suffix'), "\n")
	endif
    elseif a:how ==# 'S'
	let l:pasteType = 'V'
	let [l:isPrefix, l:isSuffix] = UnconditionalPaste#Separators#Check('V', a:1, '\s', 1)
	let l:prefix = (l:isPrefix ? repeat("\n", max([l:count, 1])) : '')
	let l:suffix = (l:isSuffix ? repeat("\n", max([l:count, 1])) : '')
	let l:count = 0

	if a:regType ==# 'V'
	    let l:pasteContent = l:prefix . substitute(a:regContent, '^\n*\(.\{-}\)\n*$', '\1\n', '') . l:suffix
	else
	    let l:pasteContent = l:prefix . a:regContent . "\n" . l:suffix
	endif
    elseif a:how =~# '^\%(qb\|QB\|B\)$'
	if a:how ==# 'B'
	    let l:separator = ''
	elseif a:how ==# 'QB'
	    let l:separator = g:UnconditionalPaste_Separator
	elseif a:how ==# 'qb'
	    let l:separator = input('Enter separator string: ')
	    if empty(l:separator)
		throw 'beep'
	    endif
	    let l:separator = ingo#cmdargs#GetUnescapedExpr(l:separator)
	    let g:UnconditionalPaste_Separator = l:separator
	else
	    throw 'ASSERT: Invalid how: ' . string(a:how)
	endif


	let l:isMultiLine = (l:pasteContent =~# '\n')
	if l:isMultiLine && a:1 ==# 'P' && search('^\s\+\%#\S', 'bcnW', line('.')) != 0
	    let [l:isPrefix, l:isSuffix, l:pasteType] = [0, 1, 'prepend']
	elseif l:isMultiLine && a:1 ==# 'p' && ingo#cursor#IsAtEndOfLine() && getline('.') =~# '.'
	    let [l:isPrefix, l:isSuffix, l:pasteType] = [1, 0, 'append']
	else
	    if a:how ==# 'B'
		let [l:isPrefix, l:isSuffix] = [0, 0]
	    else
		let [l:isPrefix, l:isSuffix] = UnconditionalPaste#Separators#Check('v', a:1, '\V\C' . escape(l:separator, '\'), 0)
	    endif
	    let l:pasteType = "\<C-v>"
	endif
	let l:prefix = (l:isPrefix ? l:separator : '')
	let l:suffix = (l:isSuffix ? l:separator : '')

	let l:lines = split(l:pasteContent, '\n', 1)
	if a:regType ==# 'V' && empty(l:lines[-1]) | call remove(l:lines, -1) | endif
	call map(
	    \	l:lines,
	    \	'l:prefix . (l:count > 1 ? repeat(v:val . l:separator, l:count - 1) : "") . v:val . l:suffix'
	\)
	let l:count = 0

	if l:pasteType ==# 'prepend'
	    call UnconditionalPaste#Separators#SpecialPasteLines(l:lines, '^\s*\zs\S\|$', '')
	    return ['', '', 0, '', 0]
	elseif l:pasteType ==# 'append'
	    call UnconditionalPaste#Separators#SpecialPasteLines(l:lines, '$', '')
	    return ['', '', 0, '', 0]
	elseif l:isMultiLine
	    let l:pasteColExpr = '\%>' . (virtcol('.') - (a:1 ==# 'P' ? 1 : 0)) . 'v'
	    let l:newLineIndent = repeat(' ', virtcol('.') - (a:1 ==# 'P' ? 1 : 0))
	    call UnconditionalPaste#Separators#SpecialPasteLines(l:lines, l:pasteColExpr, l:newLineIndent)
	    return ['', '', 0, '', 0]
	endif

	let l:pasteContent = join(l:lines, "\n")
    elseif a:how ==? 'p' || a:how ==? '.p'
	let l:pasteType = a:regType " Keep the original paste type.
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

	let l:IncrementFunc = (a:how ==# 'p' || a:how ==# '.p' ? 'UnconditionalPaste#Increment#Single' : 'UnconditionalPaste#Increment#Global')
	let [s:lastVcol, l:pasteContent] = call(l:IncrementFunc, [a:regContent, l:vcol, l:offset * l:baseCount])
	if l:pasteContent ==# a:regContent
	    " No number was found in the register; this is probably not what
	    " the user intended (maybe wrong register?), so don't just
	    " insert the contents unchanged, but rather alert the user.
	    throw 'beep'
	endif

	if l:count > 1
	    " To increment each multiplied paste one more, we need to
	    " process the multiplication on our own.
	    let l:numbers = (l:offset > 0 ? range(l:baseCount, l:baseCount + l:count - 1) : range(-1 * (l:baseCount + l:count - 1), -1 * l:baseCount))
	    let l:pasteContent = join(map(l:numbers, l:IncrementFunc . '(a:regContent, l:vcol, v:val)[1]'), (a:regType[0] ==# "\<C-v>" ? "\n" : ''))
	    let s:lastCount = l:baseCount + l:count - 1
	    let l:count = 0
	endif
    elseif a:how ==? 'u' || a:how ==# '~'
	let l:pasteType = a:regType " Keep the original paste type.
	if a:how ==# 'u'
	    let l:conversion = ['\<\u', '\l&']
	elseif a:how ==# 'U'
	    let l:conversion = ['\<\l', '\u&']
	elseif a:how ==# '~'
	    let l:conversion = ['\<\(\l\)\|\(\u\)', '\u\1\l\2']
	else
	    throw 'ASSERT: Invalid a:how: ' . string(a:how)
	endif

	let l:count = max([1, l:count])
	while l:count > 0
	    let l:pasteContent = substitute(l:pasteContent, l:conversion[0], l:conversion[1], '')
	    let l:count -=1
	endwhile

	if l:pasteContent ==# a:regContent
	    " No change in case has been performed; this is probably not
	    " what the user intended.
	    throw 'beep'
	endif
    elseif a:how ==# 'h'
	let l:types = filter(
	\   map(copy(g:UnconditionalPaste_Mappings), 'v:val[1]'),
	\   'v:val[0] !~# "^[.h]$"'
	\)

	let l:localCount = ''
	let l:howList = []
	while 1
	    call ingo#query#Question(printf('Paste as %s (%s/<Enter>=go/<Esc>=abort/?=help)', join(l:howList, ' + '), join(l:types, '/')))
	    let l:key = ingo#query#get#Char()

	    while l:key =~# '\d'
		" Keep reading local count until a real how happens.
		let l:localCount .= l:key
		let l:key = ingo#query#get#Char()
	    endwhile

	    if empty(l:key)
		redraw
		return ['', '', 0, '', 0]
	    elseif l:key ==# "\r"
		break
	    elseif l:key ==# '?'
		call s:PrintHelp(l:types, l:howList)
		continue
	    elseif empty(l:localCount) && ! empty(l:howList) && index(l:types, l:howList[-1] . l:key) != -1
		" Is a two-key type where the first key also is a valid type on
		" its own; revise the previous recognized type now.
		let l:howList[-1] .= l:key
	    elseif index(l:types, l:key) != -1
		call add(l:howList, l:localCount . l:key)
		let l:localCount = ''
	    elseif ! empty(filter(copy(l:types), 'v:val =~# "^" . l:key'))
		" Might be a two-key type (where the first key isn't a valid
		" type on its own); get another key.
		let l:key2 = ingo#query#get#Char()
		if empty(l:key2)
		    redraw
		    return ['', '', 0, '', 0]
		elseif index(l:types, l:key . l:key2) != -1
		    call add(l:howList, l:localCount . l:key . l:keys)
		    let l:localCount = ''
		endif
	    endif
	endwhile

	let l:pasteType = a:regType
	for l:how in l:howList
	    let [l:localCount, l:how] = matchlist(l:how, '^\(\d*\)\(.*\)$')[1:2]
	    let [l:pasteContent, l:pasteType, l:count, l:shiftCommand, l:shiftCount] = call('s:ApplyAlgorithm', [l:how, l:pasteContent, l:pasteType, (! empty(l:localCount) ? 0 + l:localCount : a:count), l:shiftCommand, l:shiftCount] + a:000)
	endfor
    elseif a:how =~# '^[rR]!\?$'
	let l:isInverse = (a:how[1] ==# '!')
	if a:how[0] ==# 'r'
	    let l:pattern = input(printf('Enter %sfilter pattern: ', (l:isInverse ? 'inverse ': '')))
	    if empty(l:pattern)
		throw 'beep'
	    endif
	    if l:isInverse
		let g:UnconditionalPaste_InvertedGrepPattern = l:pattern
	    else
		let g:UnconditionalPaste_GrepPattern = l:pattern
	    endif
	else
	    if l:isInverse
		let l:pattern = g:UnconditionalPaste_InvertedGrepPattern
	    else
		let l:pattern = g:UnconditionalPaste_GrepPattern
	    endif
	endif

	let l:pasteType = a:regType
	let l:lines = split(l:pasteContent, '\n', 1)
	call filter(l:lines, 'v:val ' . (l:isInverse ? '!' : '=') . '~ l:pattern')

	let l:joiner = (s:IsSingleElement(a:regContent) ?
	\   matchstr(a:regContent, g:UnconditionalPaste_UnjoinSeparatorPattern) :
	\   "\n"
	\)
	let l:pasteContent = join(l:lines, l:joiner)
    elseif a:how ==? 'e'
	if a:how ==# 'e'
	    let l:expression = input('Enter expression: ', 'v:val')
	    if empty(l:expression)
		throw 'beep'
	    endif
	    let g:UnconditionalPaste_Expression = l:expression
	endif

	let l:pasteType = a:regType
	let l:lines = split(l:pasteContent, '\n', 1)

	if l:count > 1
	    " To map the multiplied pastes with the (potentially non-constant)
	    " expression, we need to process the multiplication on our own.
	    let l:lines = repeat(l:lines, l:count)
	    let l:count = 0
	endif

	let l:lines = ingo#collections#Flatten1(map(l:lines, g:UnconditionalPaste_Expression))

	let l:joiner = (s:IsSingleElement(a:regContent) ?
	\   matchstr(a:regContent, g:UnconditionalPaste_UnjoinSeparatorPattern) :
	\   "\n"
	\)
	let l:pasteContent = join(l:lines, l:joiner)
    elseif a:how ==# '\' || a:how ==# '\\'
	if a:how ==# '\\'
	    if ! exists('g:UnconditionalPaste_Escape')
		let g:UnconditionalPaste_Escape = get(ingo#plugin#setting#GetBufferLocal('UnconditionalPaste_Escapes'), 0, s:CompleteEscape({}))
	    endif
	elseif a:how ==# '\'
	    if ! s:QueryEscape(l:count)
		throw 'beep'
	    endif
	    let l:count = 0
	else
	    throw 'ASSERT: Unhandled a:how: ' . string(a:how)
	endif

	let l:pasteType = a:regType
	if has_key(g:UnconditionalPaste_Escape, 'pattern')
	    let l:pasteContent = substitute(l:pasteContent, g:UnconditionalPaste_Escape.pattern, g:UnconditionalPaste_Escape.replacement, 'g')
	endif
	if has_key(g:UnconditionalPaste_Escape, 'Replacer')
	    let l:pasteContent = ingo#actions#EvaluateWithValOrFunc(g:UnconditionalPaste_Escape.Replacer, l:pasteContent)
	endif
    else
	throw 'ASSERT: Unknown a:how: ' . string(a:how)
    endif

    return [l:pasteContent, l:pasteType, l:count, l:shiftCommand, l:shiftCount]
endfunction
function! UnconditionalPaste#Paste( regName, how, ... )
    let l:count = v:count
    let s:count = v:count
    let l:regType = getregtype(a:regName)
    let l:regContent = getreg(a:regName, 1) " Expression evaluation inside function context may cause errors, therefore get unevaluated expression when a:regName ==# '='.

    if a:regName =~# '[=:.%]'
	" Cannot evaluate the expression register within a function; unscoped
	" variables do not refer to the global scope. Therefore, evaluation
	" happened earlier in the mappings, and stored this in s:exprResult.
	" To get the expression result into the buffer, use the unnamed
	" register, and restore it later.
	let l:regName = '"'
	let l:regContent = (a:regName ==# '=' ? s:exprResult : getreg(a:regName))

	" Note: Because of the conditional and because there is no yank
	" involved, do not use ingo#register#KeepRegisterExecuteOrFunc() here.
	let l:save_clipboard = &clipboard
	set clipboard= " Avoid clobbering the selection and clipboard registers.
	let l:save_reg = getreg(l:regName)
	let l:save_regmode = getregtype(l:regName)
    else
	let l:regName = a:regName
    endif

    try
	let [l:pasteContent, l:pasteType, l:count, l:shiftCommand, l:shiftCount] = call('s:ApplyAlgorithm', [a:how, l:regContent, l:regType, l:count, '', 0] + a:000)


	if a:0
	    if ! empty(l:pasteContent)
		call setreg(l:regName, l:pasteContent, l:pasteType)
		    execute 'normal! "' . l:regName . (l:count ? l:count : '') . a:1
		call setreg(l:regName, l:regContent, l:regType)
	    endif

	    if ! empty(l:shiftCommand)
		for l:cnt in range(l:shiftCount)    " Repeatedly use the :> command; multiple shiftwidths can only be indented from visual mode, but we don't want to clobber the selection, and expect only low [count]s, anyway.
		    execute "silent '[,']" . l:shiftCommand
		endfor
	    endif
	    return 1
	else
	    return l:pasteContent
	endif
    catch /^beep$/
	execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	return (a:0 ? 1 : '')
    catch /^Vim\%((\a\+)\)\=:/
	if a:0
	    call ingo#err#SetVimException()
	    return 0
	else
	    call ingo#cmdline#showmode#TemporaryNoShowMode()
	    call ingo#msg#VimExceptionMsg()
	    return ''
	endif
    finally
	if a:regName =~# '[=:.%]'
	    call setreg('"', l:save_reg, l:save_regmode)
	    let &clipboard = l:save_clipboard
	endif
    endtry
endfunction
function! UnconditionalPaste#Insert( regName, how, isBeep )
    if a:regName !~? '[0-9a-z"%#*+:.-]'
	" Note the lack of "="; we don't support the expression register here,
	" because we would need to do the querying and evaluation all by
	" ourselves.
	if a:isBeep
	    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	endif
	return ''
    endif

    return UnconditionalPaste#Paste(a:regName, a:how)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
