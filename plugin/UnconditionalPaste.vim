" UnconditionalPaste.vim: Force character-/line-/block-wise paste, regardless of
" how it was yanked. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - repeat.vim (vimscript #2136) autoload script (optional). 

" Copyright: (C) 2006-2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" Source: Based on vimtip #1199 by cory, 
"	  http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
"
" REVISION	DATE		REMARKS 
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

function! s:HandleExprReg( exprResult )
    let s:exprResult = a:exprResult
endfunction

function! s:Flatten( text )
    " Remove newline characters at the end of the text, convert all other
    " newlines to a single space. 
    return substitute(substitute(a:text, "\n\\+$", '', 'g'), "\n\\+", ' ', 'g')
endfunction

function! s:Paste( regName, pasteType, pasteCmd )
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
	call setreg(l:regName, (a:pasteType ==# 'c' ? s:Flatten(l:regContent) : l:regContent), a:pasteType)
	execute 'normal! "' . l:regName . (v:count ? v:count : '') . a:pasteCmd
	call setreg(l:regName, l:regContent, l:regType)
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

function! s:CreateMappings()
    for [l:pasteName, pasteType] in [['Char', 'c'], ['Line', 'l'], ['Block', 'b']]
	for [l:direction, l:pasteCmd] in [['After', 'p'], ['Before', 'P']]
	    let l:mappingName = 'UnconditionalPaste' . l:pasteName . l:direction
	    let l:plugMappingName = '<Plug>' . l:mappingName
	    execute printf('nnoremap <silent> %s :<C-u>' .
	    \	'silent! call repeat#setreg("\<lt>Plug>%s", v:register)<Bar>' .
	    \	'if v:register ==# "="<Bar>' .
	    \	'    call <SID>HandleExprReg(getreg("="))<Bar>' .
	    \	'endif<Bar>' .
	    \	'call <SID>Paste(v:register, %s, %s)<Bar>' .
	    \	'silent! call repeat#set("\<lt>Plug>%s")<CR>',
	    \
	    \	l:plugMappingName,
	    \	l:mappingName,
	    \	string(l:pasteType),
	    \	string(l:pasteCmd),
	    \	l:mappingName
	    \)
	    if ! hasmapto(l:plugMappingName, 'n')
		execute printf('nmap g%s%s %s',
		\   l:pasteType,
		\   l:pasteCmd,
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
