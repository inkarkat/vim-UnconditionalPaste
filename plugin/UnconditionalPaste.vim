" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of
" how it was yanked.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - UnconditionalPaste.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)

" Copyright: (C) 2006-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory,
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
"
" REVISION	DATE		REMARKS
"   3.10.031	03-Dec-2014	Add g,'p and g,"p variants of g,p.
"   3.02.034	17-Jun-2014	CHG: Change default mappings of gdp and gDp to
"				gqbp and gQBp, respectively.
"   3.00.033	21-Mar-2014	Add gBp mapping to paste as a minimal fitting
"				block with jagged right edge, a separator-less
"				variant of gDp.
"				Add g>p mapping to paste shifted register
"				contents.
"				Add g:UnconditionalPaste_IsFullLineRetabOnShift
"				configuration whether to use the
"				AlignFromCursor.vim functionality if it's there.
"				Add g]]p and g[[p mappings to paste like with
"				g]p, but with more / less indent.
"   3.00.032	20-Mar-2014	Add gdp / gDp mappings to paste as a minimal
"				fitting block with (queried / recalled)
"				separator string, with special cases at the end
"				of leading indent and at the end of the line.
"   3.00.031	19-Mar-2014	Add g#p mapping to apply 'commentstring' to each
"				indented linewise paste.
"				Add gsp mapping to paste with [count] spaces /
"				empty lines around the register contents.
"   3.00.030	14-Mar-2014	ENH: Extend CTRL-R insert mode mappings to
"				command-line mode.
"   2.20.020	18-Mar-2013	ENH: Add g]p / g]P mappings to paste linewise
"				with adjusted indent. Thanks to Gary Fixler for
"				the suggestion.
"   2.20.019	18-Mar-2013	ENH: Add gPp / gPP mappings to paste with all
"				numbers incremented / decremented.
"   2.10.018	22-Dec-2012	FIX: Do not re-query on repeat of the mapping.
"				This wasn't updated for the Query mapping and
"				not implemented at all for the Unjoin mapping.
"   2.10.017	21-Dec-2012	ENH: Add mappings to paste with one number
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

if ! exists('g:UnconditionalPaste_IsFullLineRetabOnShift')
    let g:UnconditionalPaste_IsFullLineRetabOnShift = 0
endif


"- mappings --------------------------------------------------------------------

function! s:CreateMappings()
    for [l:pasteName, l:pasteType] in
    \   [
    \       ['Char', 'c'], ['Line', 'l'], ['Block', 'b'], ['Comma', ','], ['CommaSingleQuote', ",'"], ['CommaDoubleQuote', ',"'],
    \       ['Indented', 'l'],
    \       ['MoreIndent', 'm'], ['LessIndent', 'n'],
    \       ['Shifted', '>'],
    \       ['Commented', '#'],
    \       ['Spaced', 's'],
    \       ['Jagged', 'B'],
    \       ['Delimited', 'qb'], ['RecallDelimited', 'QB'],
    \       ['Queried', 'q'], ['RecallQueried', 'Q'],
    \       ['Unjoin', 'u'], ['RecallUnjoin', 'U'],
    \       ['Plus', 'p'], ['PlusRepeat', '.p'],
    \       ['GPlus', 'P'], ['GPlusRepeat', '.P']
    \   ]
	for [l:direction, l:pasteCmd] in [['After', 'p'], ['Before', 'P']]
	    let l:mappingName = 'UnconditionalPaste' . l:pasteName . l:direction
	    let l:plugMappingName = '<Plug>' . l:mappingName

	    " Do not create default mappings for the special paste repeats.
	    let l:pasteMappingDefaultKeys = (l:pasteType[0] == '.' ? '' : l:pasteType . l:pasteCmd)


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
	    endif
	    if l:pasteType ==# 'qb' || l:pasteType ==# 'q' || l:pasteType ==# 'u'
		" On repeat of one of the mappings that query, we want to skip
		" the query and recall the last queried separator instead.
		let l:mappingName = 'UnconditionalPasteRecall' . l:pasteName . l:direction
	    elseif l:pasteType ==? 'p'
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
	    \   'call UnconditionalPaste#Paste(v:register, %s, %s)<Bar>' .
	    \   'silent! call repeat#set("\<lt>Plug>%s", UnconditionalPaste#GetCount())<CR>',
	    \
	    \   l:plugMappingName,
	    \   l:mappingName,
	    \   string(l:pasteType),
	    \   string(l:pasteCmd),
	    \   l:mappingName
	    \)
	    if ! hasmapto(l:plugMappingName, 'n') && ! empty(l:pasteMappingDefaultKeys)
		execute printf('nmap g%s %s',
		\   l:pasteMappingDefaultKeys,
		\   l:plugMappingName
		\)
	    endif
	endfor
    endfor

    for [l:pasteName, l:pasteType, l:pasteKey] in
    \   [
    \       ['Char', 'c', '<C-c>'], ['Comma', ',', ','],
    \       ['Queried', 'q', '<C-q>'], ['RecallQueried', 'Q', '<C-q><C-q>'],
    \       ['Unjoin', 'u', '<C-u>'], ['RecallUnjoin', 'U', '<C-u><C-u>']
    \   ]
	let l:plugMappingName = '<Plug>UnconditionalPaste' . l:pasteName
	" XXX: Can only use i_CTRL-R here (though I want literal insertion, not
	" as typed); i_CTRL-R_CTRL-R with the expression register cannot insert
	" newlines (^@ are inserted), and i_CTRL-R_CTRL-O inserts above the
	" current line when the register ends with a newline.
	for l:mode in ['i', 'c']
	    execute printf('%snoremap <silent> %s <C-r>=UnconditionalPaste#Insert(nr2char(getchar()), %s, %d)<CR>',
	    \   l:mode,
	    \   l:plugMappingName,
	    \   string(l:pasteType),
	    \   (l:mode ==# 'i')
	    \)
	    if ! hasmapto(l:plugMappingName, l:mode)
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
