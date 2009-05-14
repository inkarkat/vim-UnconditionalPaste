" UnconditionalPaste.vim: Force linewise or characterwise paste, regardless of
" how it was yanked. 
"
" DESCRIPTION:
"   If you're like me, you occassionally do a linewise yank, and then want to
"   insert that yanked text in the middle of some other line, (or vice versa).
"   This function and mapping will allow you to do a linewise or characterwise
"   paste no matter how you yanked the text.

" Copyright: (C) 2006-2008 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	007	15-May-2009	Now catching and reporting any errors caused by
"				the paste. 
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

" Avoid installing twice. 
if exists('g:loaded_UnconditionalPaste')
    finish
endif
let g:loaded_UnconditionalPaste = 1

function! s:Flatten(text)
    " Remove newline characters at the end of the text, convert all other
    " newlines to a single space. 
    return substitute(substitute(a:text, "\n\\+$", '', 'g'), "\n\\+", ' ', 'g')
endfunction

function! s:Paste(regName, pasteType, pasteCmd)
    try
	let l:regType = getregtype(a:regName)
	let l:regContent = getreg(a:regName)
	call setreg(a:regName, (a:pasteType ==# 'c' ? s:Flatten(l:regContent) : l:regContent), a:pasteType)
	execute 'normal! "' . a:regName . a:pasteCmd
	call setreg(a:regName, l:regContent, l:regType)
    catch /^Vim\%((\a\+)\)\=:E/
	echohl ErrorMsg
	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away. 
	let v:errmsg = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
	echomsg v:errmsg
	echohl None
    endtry
endfunction

"["x]glp, ["x] glP	Paste linewise (even if yanked text is not a complete line). 
"["x]gcp, ["x] gcP	Paste characterwise (newlines are flattened to spaces). 
nnoremap <silent> glP :call <SID>Paste(v:register, 'l', 'P')<CR>
nnoremap <silent> glp :call <SID>Paste(v:register, 'l', 'p')<CR>
nnoremap <silent> gcP :call <SID>Paste(v:register, 'c', 'P')<CR>
nnoremap <silent> gcp :call <SID>Paste(v:register, 'c', 'p')<CR>

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
