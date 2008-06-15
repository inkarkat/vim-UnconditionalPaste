" UnconditionalPaste.vim: Unconditional linewise or characterwise paste. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	004	30-May-2007	Added <silent> to the mapping to avoid echoing
"				of the function invocation. 
"	0.03	13-May-2006	Changed mappings from <leader>.. to g.., as
"				this is easier to type (and 'g' often introduces
"				alternative actions (like 'j' and 'gj')). 
"	0.02	10-Apr-2006	Added flattening (replacing newlines with
"				spaces) for characterwise paste. 
"	0.01	10-Apr-2006	file creation from vimtip #1199

" Avoid installing twice or when in compatible mode
if exists("loaded_UnconditionalPaste")
    finish
endif
let loaded_UnconditionalPaste = 1

" If you're like me, you occassionally do a linewise yank, and then want to
" insert that yanked text in the middle of some other line, (or vice versa).
" This function and mapping will allow you to do a linewise or characterwise
" paste no matter how you yanked the text.

function! s:Paste(regname, pasteType, pastecmd)
    let reg_type = getregtype(a:regname)
    call setreg(a:regname, getreg(a:regname), a:pasteType)
    execute 'normal "' . a:regname . a:pastecmd
    call setreg(a:regname, getreg(a:regname), reg_type)
endfunction

function! s:FlattenRegister(regname)
    execute 'let @' . a:regname . '=substitute(@' . a:regname . ',"\n"," ","g")'
endfunction

nmap <silent> glP :call <SID>Paste(v:register, "l", "P")<CR>
nmap <silent> glp :call <SID>Paste(v:register, "l", "p")<CR>
nmap <silent> gcP :call <SID>FlattenRegister(v:register)<bar>call <SID>Paste(v:register, "v", "P")<CR>
nmap <silent> gcp :call <SID>FlattenRegister(v:register)<bar>call <SID>Paste(v:register, "v", "p")<CR>

