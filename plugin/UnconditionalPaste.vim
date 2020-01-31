" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of how it was yanked.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo-library.vim plugin
"   - repeat.vim (vimscript #2136) plugin (optional)

" Copyright: (C) 2006-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory,
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_UnconditionalPaste') || (v:version < 700)
    finish
endif
let g:loaded_UnconditionalPaste = 1

let s:save_cpo = &cpo
set cpo&vim

"- configuration ---------------------------------------------------------------

if ! exists('g:UnconditionalPaste_Separator')
    let g:UnconditionalPaste_Separator = "\t"
endif
if ! exists('g:UnconditionalPaste_JoinSeparator')
    let g:UnconditionalPaste_JoinSeparator = "\t"
endif
if ! exists('g:UnconditionalPaste_UnjoinSeparatorPattern')
    let g:UnconditionalPaste_UnjoinSeparatorPattern = '\_s\+'
endif
if ! exists('g:UnconditionalPaste_GrepPattern')
    let g:UnconditionalPaste_GrepPattern = '\S'
endif
if ! exists('g:UnconditionalPaste_InvertedGrepPattern')
    let g:UnconditionalPaste_InvertedGrepPattern = '^\s*$'
endif
if ! exists('g:UnconditionalPaste_Expression')
    let g:UnconditionalPaste_Expression = 'substitute(v:val, "(.*)", "()", "g")'
endif
if ! exists('g:UnconditionalPaste_Escapes')
    let g:UnconditionalPaste_Escapes = [{
    \   'name': 'backslash',
    \   'pattern': '\\',
    \   'replacement': '\\&'
    \}]
endif
if ! exists('g:UnconditionalPaste_Combinations')
    let g:UnconditionalPaste_Combinations = ['S', '>']
endif

if ! exists('g:UnconditionalPaste_IsFullLineRetabOnShift')
    let g:UnconditionalPaste_IsFullLineRetabOnShift = 0
endif
if ! exists('g:UnconditionalPaste_IsSerialComma')
    let g:UnconditionalPaste_IsSerialComma = 1
endif

let g:UnconditionalPaste_Mappings =
    \   [
    \       ['Char', 'c', '<C-c>'], ['Inlined', 'ci', '<C-i>'], ['JustJoined', 'cg'], ['CharCondensed', 'C', '<C-c><C-c>'],
    \       ['Line', 'l'], ['Block', 'b'],
    \       ['Comma', ',', ','],
    \       ['CommaAnd', ',a'], ['CommaOr', ',o'], ['CommaNor', ',n'],
    \       ['CommaSingleQuote', ",'"], ['CommaDoubleQuote', ',"'],
    \       ['Indented', 'i'],
    \       ['MoreIndent', 'm'], ['LessIndent', 'n'],
    \       ['Shifted', '>'],
    \       ['Commented', '#'],
    \       ['Spaced', 's'], ['Paragraphed', 'S'],
    \       ['Jagged', 'B'],
    \       ['Delimited', 'qb'], ['RecallDelimited', 'QB'],
    \       ['Queried', 'q', '<C-q>'], ['RecallQueried', 'Q', '<C-q><C-q>'],
    \       ['QueriedJoined', 'qg', '<C-q><C-g>'], ['RecallQueriedJoined', 'Qg', '<C-q><C-q><C-g><C-g>'],
    \       ['Unjoin', 'uj', '<C-u>'], ['RecallUnjoin', 'UJ', '<C-u><C-u>'],
    \       ['Grep', 'r'], ['RecallGrep', 'R'],
    \       ['InvertedGrep', 'r!'], ['RecallInvertedGrep', 'R!'],
    \       ['Expression', 'e'], ['RecallExpression', 'E'],
    \       ['Escape', '\', '<C-\>'], ['RecallEscape', '\\', '<C-\><C-\>'],
    \       ['Plus', 'p'], ['PlusRepeat', '.p'],
    \       ['GPlus', 'P'], ['GPlusRepeat', '.P'],
    \       ['Lowercase', 'u'], ['Uppercase', 'U'], ['Togglecase', '~', '~'],
    \       ['Combinatorial', 'h', '<C-h>'], ['RecallCombinatorial', 'H', '<C-h><C-h>']
    \   ]

"- mappings --------------------------------------------------------------------

function! s:CreateMappings()
    for l:mapping in copy(g:UnconditionalPaste_Mappings)
	let [l:pasteName, l:how] = l:mapping[0:1]
	for [l:direction, l:pasteCmd] in [['After', 'p'], ['Before', 'P']]
	    let l:mappingName = 'UnconditionalPaste' . l:pasteName . l:direction
	    let l:plugMappingName = '<Plug>' . l:mappingName

	    " Do not create default mappings for the special paste repeats.
	    let l:pasteMappingDefaultKeys = (l:how[0] == '.' ? '' : l:how . l:pasteCmd)


	    if l:pasteName =~# 'Indent\|^Commented$'
		if l:pasteName ==# 'Indented'
		    let l:pasteMappingDefaultKeys = ']' . l:pasteCmd

		    " Define additional variations like with the built-in ]P.
		    if ! hasmapto('<Plug>UnconditionalPasteIndentBefore', 'n')
			nmap g]P <Plug>UnconditionalPasteIndentedBefore
			nmap g[P <Plug>UnconditionalPasteIndentedBefore
			nmap g[p <Plug>UnconditionalPasteIndentedBefore
		    endif
		elseif l:pasteName ==# 'MoreIndent'
		    let l:pasteMappingDefaultKeys = ']]' . l:pasteCmd
		elseif l:pasteName ==# 'LessIndent'
		    let l:pasteMappingDefaultKeys = '[[' . l:pasteCmd
		endif

		" This is a variant of forced linewise paste (glp) that uses ]p
		" instead of p for pasting.
		let l:pasteCmd = ']' . l:pasteCmd
	    elseif l:pasteName ==# 'Expression'
		" ge / gE are built-in motions; we don't want to introduce a
		" delay there by creating mappings starting with the same
		" key sequence.
		let l:pasteMappingDefaultKeys = '=' . l:pasteCmd
	    elseif l:pasteName ==# 'RecallExpression'
		let l:pasteMappingDefaultKeys = '==' . l:pasteCmd
	    endif

	    if index(['Delimited', 'Queried', 'Unjoin', 'Grep', 'InvertedGrep', 'Expression', 'Combinatorial'], l:pasteName) != -1
		" On repeat of one of the mappings that query, we want to skip
		" the query and recall the last queried separator instead.
		let l:mappingName = 'UnconditionalPasteRecall' . l:pasteName . l:direction
	    elseif index(['Plus', 'GPlus'], l:pasteName) != -1
		" On repeat of the UnconditionalPastePlus /
		" UnconditionalPasteGPlus mappings, we want to continue
		" increasing with the last used (saved) offset, and at the same
		" number position (after the first paste, the cursor will have
		" jumped to the beginning of the pasted text).
		let l:mappingName = 'UnconditionalPaste' . l:pasteName . 'Repeat' . l:direction
	    endif


	    execute printf('nnoremap <silent> %s :<C-u>' .
	    \   'execute ''silent! call repeat#setreg("\<lt>Plug>%s", v:register)''<Bar>' .
	    \   'if v:register ==# "="<Bar>' .
	    \   '    call UnconditionalPaste#HandleExprReg(getreg("="))<Bar>' .
	    \   'endif<Bar>' .
	    \   'if ! UnconditionalPaste#Paste(v:register, "n", %s, %s)<Bar>' .
	    \   '   echoerr ingo#err#Get()<Bar>' .
	    \   'endif<Bar>' .
	    \   'silent! call repeat#set("\<lt>Plug>%s", UnconditionalPaste#GetCount())<CR>',
	    \
	    \   l:plugMappingName,
	    \   l:mappingName,
	    \   string(l:how),
	    \   string(l:pasteCmd),
	    \   l:mappingName
	    \)
	    if ! exists('g:UnconditionalPaste_no_mappings') && ! hasmapto(l:plugMappingName, 'n') && ! empty(l:pasteMappingDefaultKeys)
		execute printf('nmap g%s %s',
		\   l:pasteMappingDefaultKeys,
		\   l:plugMappingName
		\)
	    endif
	endfor
    endfor

    for [l:pasteName, l:how, l:pasteKey] in filter(copy(g:UnconditionalPaste_Mappings), '! empty(get(v:val, 2, ""))')
	let l:plugMappingName = '<Plug>UnconditionalPaste' . l:pasteName . 'I'
	" XXX: Can only use i_CTRL-R here (though I want literal insertion, not
	" as typed); i_CTRL-R_CTRL-R with the expression register cannot insert
	" newlines (^@ are inserted), and i_CTRL-R_CTRL-O inserts above the
	" current line when the register ends with a newline.
	for l:mode in ['i', 'c']
	    execute printf('%snoremap <silent> %s <C-r>=UnconditionalPaste#Insert(nr2char(getchar()), %s, %s, %d)<CR>',
	    \   l:mode,
	    \   l:plugMappingName,
	    \   string(l:mode),
	    \   string(l:how),
	    \   (l:mode ==# 'i')
	    \)
	    if ! exists('g:UnconditionalPaste_no_mappings') && ! hasmapto(l:plugMappingName, l:mode)
		execute printf('%smap <C-r>%s %s',
		\   l:mode,
		\   l:pasteKey,
		\   l:plugMappingName
		\)
	    endif
	endfor
    endfor
endfunction
call s:CreateMappings()
delfunction s:CreateMappings

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
