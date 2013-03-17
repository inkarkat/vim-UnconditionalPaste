" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of
" how it was yanked.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - UnconditionalPaste.vim autoload script
"   - repeat.vim (vimscript #2136) autoload script (optional)

" Copyright: (C) 2006-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory,
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
"
" REVISION	DATE		REMARKS
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

if ! exists('g:UnconditionalPaste_JoinSeparator')
    let g:UnconditionalPaste_JoinSeparator = "\t"
endif
if ! exists('g:UnconditionalPaste_UnjoinSeparatorPattern')
    let g:UnconditionalPaste_UnjoinSeparatorPattern = '\_s\+'
endif



"- mappings --------------------------------------------------------------------

function! s:CreateMappings()
    for [l:pasteName, pasteType] in
    \   [
    \       ['Char', 'c'], ['Line', 'l'], ['Block', 'b'], ['Comma', ','],
    \       ['Queried', 'q'], ['RecallQueried', 'Q'],
    \       ['Unjoin', 'u'], ['RecallUnjoin', 'U'],
    \       ['Plus', 'p'], ['PlusRepeat', '.p']
    \   ]
	for [l:direction, l:pasteCmd] in [['After', 'p'], ['Before', 'P']]
	    let l:mappingName = 'UnconditionalPaste' . l:pasteName . l:direction
	    let l:plugMappingName = '<Plug>' . l:mappingName

	    if l:pasteType ==# 'q' || l:pasteType ==# 'u'
		" On repeat of one of the mappings that query, we want to skip
		" the query and recall the last queried separator instead.
		let l:mappingName = 'UnconditionalPasteRecall' . l:pasteName . l:direction
	    elseif l:pasteType ==# 'p'
		" On repeat of the UnconditionalPastePlus mapping, we want to
		" continue increasing with the last used (saved) offset, and at
		" the same number position (after the first paste, the cursor
		" will have jumped to the beginning of the pasted text).
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
	    if ! hasmapto(l:plugMappingName, 'n') && len(l:pasteType) == 1
		execute printf('nmap g%s%s %s',
		\   l:pasteType,
		\   l:pasteCmd,
		\   l:plugMappingName
		\)
	    endif
	endfor
    endfor

    for [l:pasteName, pasteType, pasteKey] in
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
	execute printf('inoremap <silent> %s <C-r>=UnconditionalPaste#Insert(nr2char(getchar()), %s)<CR>',
	\   l:plugMappingName,
	\   string(l:pasteType)
	\)
	if ! hasmapto(l:plugMappingName, 'i')
	    execute printf('imap <C-r>%s %s',
	    \   l:pasteKey,
	    \   l:plugMappingName
	    \)
	endif
    endfor
endfunction
call s:CreateMappings()
delfunction s:CreateMappings

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
