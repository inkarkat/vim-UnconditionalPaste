" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of how it was yanked.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin

" Copyright: (C) 2006-2022 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory,
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
let s:save_cpo = &cpo
set cpo&vim

function! UnconditionalPaste#HandleExprReg( exprResult )
    let s:exprResult = a:exprResult
endfunction

function! s:JoinerGenerator( Splitter, args )
    let [l:text, l:separator, l:elementPrefix, l:elementSuffix] = a:args
    let l:lines = call(a:Splitter, [l:text])

    " Add potential prefix and suffix.
    if ! empty(l:elementPrefix . l:elementSuffix)
	call map(l:lines, 'l:elementPrefix . v:val . l:elementSuffix')
    endif

    " Join with passed separator.
    return join(l:lines, l:separator)
endfunction

function! s:Trim( text, ... )
    " Remove newlines and whitespace at the begin and end of the text.
    return substitute(a:text, '^\s*\%(\n\s*\)*\|\s*\%(\n\s*\)*$', '', 'g')
endfunction
function! s:TrimAndSplit( text )
    " Remove newlines and whitespace at the begin and end of the text.
    " Split into lines on newlines (plus leading and trailing whitespace).
    return split(s:Trim(a:text), '\s*\%(\n\s*\)\+')
endfunction
function! s:Flatten( ... )
    return s:JoinerGenerator(function('s:TrimAndSplit'), a:000)
endfunction
function! s:FlattenLastDifferently( text, separator, pasteCommand, lastSeparator )
    let l:lines = s:TrimAndSplit(a:text)

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

function! s:SplitOnNewlines( text ) abort
    return split(a:text, '\n\+')
endfunction
function! s:JustJoin( ... )
    " Split into lines strictly on newlines.
    return s:JoinerGenerator(function('s:SplitOnNewlines'), a:000)
endfunction

function! s:SplitOnWhitespace( text ) abort
    return split(a:text, '\_s\+')
endfunction
function! s:JoinCondense( ... ) abort
    return s:JoinerGenerator(function('s:SplitOnWhitespace'), a:000)
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
	echo printf('Paste as %s', join(map(copy(a:howList), 's:HowToString(l:typeToName, v:val)'), ' and '))
    endif
endfunction
function! s:SplitCountAndHow( how )
    let [l:count, l:how] = matchlist(a:how, '^\(\d*\)\(.*\)$')[1:2]
    return [str2nr(l:count), l:how]
endfunction
function! s:HowToString( typeToName, how )
    let [l:count, l:type] = s:SplitCountAndHow(a:how)
    return (empty(l:count) ? '' : l:count . 'x ') . a:typeToName[l:type]
endfunction
function! s:IsPasteAfter( optionalArguments )
    if len(a:optionalArguments) == 0 || a:optionalArguments[0][-1:] ==# 'p'
	return 1
    elseif a:optionalArguments[0][-1:] ==# 'P'
	return 0
    else
	throw 'ASSERT: Unknown paste command: ' . string(a:optionalArguments[0])
    endif
endfunction

function! UnconditionalPaste#GetCount()
    return s:count
endfunction
function! s:GetChar() abort
    return ingo#query#get#Char({
    \   'isAllowDigraphs': 0,
    \})
endfunction
function! s:ApplyAlgorithm( mode, how, regContent, regType, count, shiftCommand, shiftCount, ... )
    let l:pasteContent = a:regContent
    let l:count = a:count
    let l:shiftCommand = a:shiftCommand
    let l:shiftCount = a:shiftCount

    if l:count == 0 && a:how =~# '\c^\%(q\?b\|r!\?\)$' && s:IsSingleElement(a:regContent)
	" Query / re-use separator pattern, and split into multiple lines
	" first.
	if a:how !=# 'QB' && a:how[0] !=# 'R'
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
    elseif a:how =~# '^[cC,qQ]g\?$\|^,[''"aon]$\|^ci$'
	let l:pasteType = 'v'
	let l:Joiner = function('s:Flatten')
	let [l:prefix, l:suffix, l:elementPrefix, l:elementSuffix, l:linePrefix, l:lineSuffix] = ['', '', '', '', '', '']

	if a:regType[0] ==# "\<C-v>"
	    let l:pasteContent = s:StripTrailingWhitespace(a:regContent)
	endif

	if a:how ==# 'c'
	    let l:separator = ' '
	elseif a:how ==# 'ci'
	    let l:separator = ''
	    let l:Joiner = function('s:Trim')
	elseif a:how ==# 'cg'
	    let l:separator = ''
	    let l:Joiner = function('s:JustJoin')
	elseif a:how ==# 'C'
	    let l:separator = ' '
	    let l:Joiner = function('s:JoinCondense')
	elseif a:how[0] ==# ','
	    let l:separator = ', '
	    if a:how[1] =~# '^[aon]$'
		let l:Joiner = function('s:FlattenLastDifferently')
		if a:how[1] ==# 'a'
		    let l:elementSuffix = ' and '
		elseif a:how[1] ==# 'o'
		    let l:elementSuffix = ' or '
		elseif a:how[1] ==# 'n'
		    if ! (s:IsPasteAfter(a:000) && l:count == 0 && s:IsSingleElement(a:regContent))
			let l:prefix = 'neither '
		    endif
		    let l:elementSuffix = ' nor '
		else
		    throw 'ASSERT: Unknown comma modifier: ' . string(a:how[1])
		endif
		let l:elementPrefix = get(a:000, 0, 'p')   " Yes, passing paste command as prefix argument to s:FlattenLastDifferently().
		if g:UnconditionalPaste_IsSerialComma
		    let l:lineNum = len(s:TrimAndSplit(l:pasteContent))
		    let l:isExactlyTwoElements = (max([l:count, 1]) * l:lineNum == 2)
		    if ! l:isExactlyTwoElements
			let l:elementSuffix = ',' . l:elementSuffix
		    endif
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

	if a:0 && ! empty(l:separator) && a:how !~# '^\%([cC]\|,[aon]\)$\|^ci$' && s:IsSingleElement(a:regContent)
	    " DWIM: Put the separator in front (gqp) / after (gqP);
	    " otherwise, the mapping is identical to normal p / P and
	    " therefore worthless. Do not do this for plain gcp / gcP, as
	    " I often use that mapping to avoid the special handling of
	    " smartput.vim, and this embellishment would counter that.
	    " For that case, better use gsp.
	    if s:IsPasteAfter(a:000)
		let l:pasteContent = l:separator . l:pasteContent
	    else
		let l:pasteContent .= l:separator
	    endif
	endif
    elseif a:how ==? 'uj'
	if a:how ==# 'uj'
	    if ! s:QuerySeparatorPattern()
		throw 'beep'
	    endif
	endif

	let l:pasteType = (a:mode ==# 'n' ? 'V' : 'v')
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

	    if a:mode ==# 'n'
		if s:IsPasteAfter(a:000)
		    call UnconditionalPaste#Shifted#SpecialShiftedAppend(l:lines, l:shiftCount)
		else
		    call UnconditionalPaste#Shifted#SpecialShiftedPrepend(l:lines, l:shiftCount)
		endif
		return ['', '', 0, '', 0]
	    else
		let l:shiftCommand = '>'
	    endif
	endif

	if a:mode !=# 'n'
	    let l:pasteContent = "\<C-u>" . l:pasteContent
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
	let [l:isPrefix, l:isSuffix] = UnconditionalPaste#Separators#Check(a:mode, 'v', s:IsPasteAfter(a:000), ingo#plugin#setting#GetBufferLocal('UnconditionalPaste_EmptySeparatorPattern'), 1)
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
	let [l:isPrefix, l:isSuffix] = UnconditionalPaste#Separators#Check(a:mode, 'V', s:IsPasteAfter(a:000), '\(', 1)
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
	if l:isMultiLine && ! s:IsPasteAfter(a:000) && search('^\s\+\%#\S', 'bcnW', line('.')) != 0
	    let [l:isPrefix, l:isSuffix, l:pasteType] = [0, 1, 'prepend']
	elseif l:isMultiLine && s:IsPasteAfter(a:000) && ingo#cursor#IsAtEndOfLine() && getline('.') =~# '.'
	    let [l:isPrefix, l:isSuffix, l:pasteType] = [1, 0, 'append']
	else
	    if a:how ==# 'B'
		let [l:isPrefix, l:isSuffix] = [0, 0]
	    else
		let [l:isPrefix, l:isSuffix] = UnconditionalPaste#Separators#Check(a:mode, 'v', s:IsPasteAfter(a:000), '\V\C' . escape(l:separator, '\'), 0)
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
	    let l:pasteColExpr = '\%>' . (virtcol('.') - (s:IsPasteAfter(a:000) ? 0 : 1)) . 'v'
	    let l:newLineIndent = repeat(' ', virtcol('.') - (s:IsPasteAfter(a:000) ? 0 : 1))
	    call UnconditionalPaste#Separators#SpecialPasteLines(l:lines, l:pasteColExpr, l:newLineIndent)
	    return ['', '', 0, '', 0]
	endif

	let l:pasteContent = join(l:lines, "\n")
    elseif a:how ==? 'p' || a:how ==? '.p'
	let l:pasteType = a:regType " Keep the original paste type.
	let l:offset = (s:IsPasteAfter(a:000) ? 1 : -1)
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
	let l:pasteType = (a:mode ==# 'n' ? a:regType : 'v')
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
    elseif a:how ==? 'h'
	let l:types = filter(
	\   map(copy(g:UnconditionalPaste_Mappings), 'v:val[1]'),
	\   'v:val[0] !~# "^[.h]$"'
	\)

	if a:how ==# 'h'
	    let l:howList = []
	    while 1
		let l:localCount = ''
		call ingo#query#Question(printf('Paste as %s (%s/<Enter>=go/<Esc>=abort/?=help)', join(l:howList, ' + '), join(l:types, '/')))
		let l:key = s:GetChar()

		while l:key =~# '^\d$'
		    " Keep reading local count until a real how happens.
		    let l:localCount .= l:key
		    let l:key = s:GetChar()
		endwhile

		if empty(l:key)
		    redraw
		    return ['', '', 0, '', 0]
		elseif l:key ==# "\r"
		    break
		elseif l:key ==# '?'
		    call s:PrintHelp(l:types, l:howList)
		elseif l:key ==# "\<BS>"
		    if len(l:howList) > 0
			call remove(l:howList, -1)
		    endif
		elseif l:key ==# 'H'
		    call extend(l:howList, g:UnconditionalPaste_Combinations)
		elseif empty(l:localCount) && ! empty(l:howList) && index(l:types, s:SplitCountAndHow(l:howList[-1])[1] . l:key) != -1
		    " Is a two-key type where the first key also is a valid type on
		    " its own; revise the previous recognized type now.
		    let l:howList[-1] .= l:key
		elseif index(l:types, l:key) != -1
		    call add(l:howList, l:localCount . l:key)
		elseif ! empty(filter(copy(l:types), 'v:val =~# "^" . l:key'))
		    " Might be a two-key type (where the first key isn't a valid
		    " type on its own); get another key.
		    let l:key2 = s:GetChar()
		    if empty(l:key2)
			redraw
			return ['', '', 0, '', 0]
		    elseif index(l:types, l:key . l:key2) != -1
			call add(l:howList, l:localCount . l:key . l:keys)
		    endif
		endif
	    endwhile
	    let g:UnconditionalPaste_Combinations = l:howList
	else
	    let l:howList = g:UnconditionalPaste_Combinations
	endif

	let l:pasteType = a:regType
	for l:how in l:howList
	    let [l:localCount, l:how] = s:SplitCountAndHow(l:how)
	    let [l:pasteContent, l:pasteType, l:count, l:shiftCommand, l:shiftCount] = call('s:ApplyAlgorithm', [a:mode, l:how, l:pasteContent, l:pasteType, (empty(l:localCount) ? a:count : l:localCount), l:shiftCommand, l:shiftCount] + a:000)
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

	if l:count > 1
	    if a:regType[0] ==# "\<C-v>" || a:regType ==# 'v' && ingo#str#StartsWith(g:UnconditionalPaste_Expression, '.')
		" Direct joining would mangle blockwise content, and if per-line
		" application of characterwise content is asked for, we also
		" need multiple lines to make sense.
		let l:pasteContent .= "\n"
	    endif
	    " To map the multiplied pastes with the (potentially non-constant)
	    " expression, we need to process the multiplication on our own.
	    let l:pasteContent = repeat(l:pasteContent, l:count)
	    let l:count = 0
	endif

	let l:pasteContent = ingo#subs#apply#FlexibleExpression(l:pasteContent, a:regType, g:UnconditionalPaste_Expression)
	if type(l:pasteContent) == type([])
	    let l:pasteContent = join(map(l:pasteContent, 'substitute(v:val, "\\n$", "", "")'), "\n")
	endif
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

	let l:pasteType = (a:mode ==# 'n' ? a:regType : 'v')
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
function! UnconditionalPaste#Paste( regName, mode, how, ... )
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
	let [l:pasteContent, l:pasteType, l:count, l:shiftCommand, l:shiftCount] = call('s:ApplyAlgorithm', [a:mode, a:how, l:regContent, l:regType, l:count, '', 0] + a:000)


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
	    let [l:clearIndent, l:pasteContent] = matchlist(l:pasteContent, "^\\(\<C-u>\\)\\?\\(.*\\)$")[1:2]
	    if ! empty(l:shiftCount)
		let l:pasteContent = repeat({'>': "\t", '<': "\<BS>"}[l:shiftCommand], l:shiftCount) . l:pasteContent
	    endif
	    if l:pasteType ==# 'V'
		let l:pasteContent = "\n" . l:clearIndent . l:pasteContent
	    endif
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
function! UnconditionalPaste#Insert( regName, mode, how, isBeep )
    if a:regName !~? '[0-9a-z"%#*+:.-]'
	" Note the lack of "="; we don't support the expression register here,
	" because we would need to do the querying and evaluation all by
	" ourselves.
	if a:isBeep
	    execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
	endif
	return ''
    endif

    return UnconditionalPaste#Paste(a:regName, a:mode, a:how)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
