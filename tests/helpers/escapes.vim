function! MyReplacer( text )
    return 'oO[' . tr(a:text, 'o', 'X') . ']Oo'
endfunction

let g:escapes = [
\   {
\      'pattern': 'o',
\      'replacement': 'X'
\   },
\   {
\      'name': 'quotes',
\      'pattern': '[''"]',
\      'replacement': '\\&'
\   },
\   {
\      'Replacer': function('MyReplacer')
\   }
\]
