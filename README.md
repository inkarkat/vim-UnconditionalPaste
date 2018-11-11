UNCONDITIONAL PASTE   
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

If you're like me, you occasionally do a linewise yank, and then want to
insert that yanked text in the middle of some other line (or vice versa).
The mappings defined by this plugin will allow you to do a character-, line-,
or block-wise paste no matter how you yanked the text, both from normal and
insert mode.

Often, the register contents aren't quite in the form you need them. Maybe you
need to convert yanked lines to comma-separated arguments, maybe join the
lines with another separator, maybe the reverse: un-joining a single line on
some pattern to yield multiple lines. Though you can do the manipulation after
pasting, this plugin offers shortcut mappings for these actions, which are
especially helpful when you need to repeat the paste multiple times.

### SOURCE

- [Based on vimtip #1199 by cory,](http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste)

### RELATED WORKS

- whitespaste.vim ([vimscript #4351](http://www.vim.org/scripts/script.php?script_id=4351)) automatically removes blank lines around
  linewise contents, and condenses inner lines to a single one. By default, it
  remaps p / P, but this can be changed.

USAGE
------------------------------------------------------------------------------

    ["x]gcp, ["x]gcP        Paste characterwise (inner newline characters and
                            indent are flattened to a single space, leading and
                            trailing removed) [count] times.

    ["x]gcgp, ["x]gcgP      Paste joined (like gJ); indent and surrounding
                            whitespace is kept as-is, [count] times.

    ["x]glp, ["x]glP        Paste linewise (even if yanked text is not a complete
                            line) [count] times.

    ["x]gbp, ["x]gbP        Paste blockwise (inserting multiple lines in-place,
                            pushing existing text further to the right) [count]
                            times. If there's only a single line to paste and no
                            [count], first query about a separator pattern and
                            un-join the register contents.

    ["x]g]p, ["x]g[P  or    Paste linewise (even if yanked text is not a complete
             ["x]g]P  or    line) [count] times like glp, but adjust the indent
             ["x]g[p        to the current line (like ]p).

    ["x]g]]p, ["x]g]]P      Paste linewise below / above, with [count] more indent
                            than the current line.
    ["x]g[[p, ["x]g[[P      Paste linewise below / above, with [count] less indent
                            than the current line.

    ["x]g>p, ["x]g>P        Paste lines with [count] times 'shiftwidth' indent.
                            For characterwise and blockwise register contents,
                            paste at the beginning / end of the line(s) with the
                            indent before (g>p) / after (g>P) each line's
                            content. Multiple characterwise lines are flattened
                            into one as with gcp. The indent of blocks is based
                            on the current line's width; if subsequent lines are
                            longer, and additional indent is added there.

    ["x]g#p, ["x]g#P        Paste linewise (even if yanked text is not a complete
                            line) as commented text [count] times. This applies
                            'commentstring' to each individual line, and adjusts
                            the indent (of the entire comment) to the current line
                            (like ]p).
                            This is useful when you want to paste indented text as
                            comments, but avoid the progressive auto-indenting
                            that would normally happen with i_CTRL-R.

    ["x]gsp, ["x]gsP        Paste with [count] spaces (characterwise; blockwise:
                            around each line; linewise: flattened like gcp)
                            around the register contents. When pasting before the
                            start or after the end of the line, or with whitespace
                            around the current position, this is added only to the
                            "other" side, unless there's emptyness at both sides.
                            (Else, you could just use plain p|/|P.)
                            Note: To paste with <Tab> instead of spaces (at the
                            beginning or end), you can use g>P / g>p if you
                            use tab-indenting or gQP / gQp (with the default
                            separator) if 'expandtab' is set.
    ["x]gSp, ["x]gSP        Paste linewise (like glp) with [count] empty lines
                            around the register contents. When pasting before the
                            start or after the end of the buffer, or with empty
                            lines around the current position, this is added only
                            to the "other" side, unless there's emptyness at both
                            sides. (Else, you could just use plain p|/|P.)

    ["x]gBp, ["x]gBP        Paste as a minimal fitting (not rectangular) block
                            with a jagged right edge; i.e. the lines
                            "foobar\nhi\n" will be pasted as 6-character "foobar"
                            in the current line and 2-character "hi" in the
                            following one.
                            With [count], each line's content is pasted [count]
                            times.
                            When pasting with gBp at the end of the line,
                            appends at the jagged end of following lines.
                            When pasting with gBP on the first non-indent
                            character (after column 1) of a line, prepends after
                            existing indent of following lines.
                            If there's only a single line to paste and no [count],
                            first query about a separator pattern and un-join the
                            register contents.

    ["x]gqbp, ["x]gqbP      Query for a separator string, then paste as a minimal
                            fitting (not rectangular) block (like gBp) with that
                            separator around each line (similar to gqp),
                            omitting the separator at the start and end of the
                            line or when there's already one at that side, like
                            with gsp.
                            With [count], each line's content is pasted [count]
                            times, with the separator between each.
                            When pasting with gqbp at the end of the line,
                            appends (with separator) at the jagged end of
                            following lines.
                            When pasting with gqbP on the first non-indent
                            character (after column 1) of a line, prepends (with
                            separator) after existing indent of following lines.
                            If there's only a single line to paste and no [count],
                            first query about a separator pattern and un-join the
                            register contents.

    ["x]gQBp, ["x]gQBP      Paste blockwise with the previously queried (gqbp)
                            separator string (and separator pattern, if single
                            line). Defaults to <Tab> separator
                            g:UnconditionalPaste_Separator.

    ["x]g,p, ["x]g,P        Paste characterwise, with each line delimited by ", "
                            instead of the newline (and indent).

    ["x]g,ap, ["x]g,aP      Paste characterwise, with each line delimited by ", "
    ["x]g,op, ["x]g,oP      and the last line delimited by ", and" / ", or" / ",
    ["x]g,np, ["x]g,nP      nor" (and "neither" appended) instead of the newline
                            (and indent).
                            Cp. g:UnconditionalPaste_IsSerialComma for comma
                            placement in front of the conjunction.

    ["x]g,'p, ["x]g,'P      Paste characterwise, with each line surrounded by
    ["x]g,"p, ["x]g,"P      single / double quotes and delimited by ", " instead
                            of the newline (and indent).

    ["x]gqp, ["x]gqP        Query for a separator string, then paste
                            characterwise, with each line delimited by it.
                            You can also additionally input a prefix (inserted
                            once before the paste) and suffix (once after the
                            paste) as {prefix}^M{separator}^M{suffix} (with ^M
                            entered as <C-V><Enter>). There's another alternative
                            form
               {prefix}^M{element-prefix}^M{separator}^M{element-suffix}^M{suffix}
                            that lets you specify prefixes and suffixes for each
                            element.
                            Examples:
                            "^M, ^M"   -> "foo, bar, baz"

                            "^M", "^M" -> "foo", "bar", "baz"
                            can also be written as:
                            ^M"^M, ^M"^M -> "foo", "bar", "baz"

                            Functions:^M^M - ^M()^M! -> Functions:foo() - bar() - baz()!

                            <ul>\n^M  <li>^M\n^M</li>^M\n</ul> -> <ul>
                                                                    <li>foo</li>
                                                                    <li>bar</li>
                                                                    <li>baz</li>
                                                                  </ul>

    ["x]gQp, ["x]gQP        Paste characterwise, with each line delimited by the
                            previously queried (gqp) separator string.
                            Defaults to <Tab> separator
                            g:UnconditionalPaste_JoinSeparator.

    ["x]gqgp, ["x]gqgP      Like gqp / gQp, but keep indent and surrounding
    ["x]gQgp, ["x]gQgP      whitespace as-is; just join the lines with the
                            separator (and prefix / suffix).

    ["x]gujp, ["x]gujP      Query for a separator pattern, un-join the register
                            contents, then paste linewise.

    ["x]gUJp, ["x]gUJP      Un-join the register contents on the previously
                            queried (gujp) separator pattern, then paste
                            linewise. Defaults to separation by any whitespace and
                            newlines g:UnconditionalPaste_UnjoinSeparatorPattern.

    ["x]grp, ["x]grP        Query for a pattern, and only paste those lines that
                            match the pattern.
    ["x]gr!p, ["x]gr!P      Query for a pattern, and only paste those lines that
                            do NOT match the pattern.
                            If there's only a single line to paste and no [count],
                            first query about a separator pattern and un-join the
                            register contents. Re-join all matches with the first
                            match of the separator pattern and paste characterwise.

    ["x]gRp, ["x]gRP        Only paste those lines that match the previously
                            queried pattern.
    ["x]gR!p, ["x]gR!P      Only paste those lines that do NOT match the
                            previously queried pattern.
                            Both default to filter out whitespace-only lines
                            g:UnconditionalPaste_GrepPattern
                            g:UnconditionalPaste_InvertedGrepPattern.
                            If there's only a single line to paste and no [count],
                            un-join the register contents first like gUJp.
                            Re-join all matches with the first match of the
                            separator pattern and paste characterwise.

    ["x]g=p, ["x]g=P        Query for an expression, apply it to each line
                            (replacing v:val with the current line), and paste the
                            resulting lines. To omit a line, return an empty List
                            ([]) from the expression. To expand a line into
                            several, return a List of lines.
                            If there's only a single line to paste and no [count],
                            first query about a separator pattern and un-join the
                            register contents. Re-join all matches with the first
                            match of the separator pattern and paste characterwise.

    ["x]g==p, ["x]g==P      Apply the previously queried expression to each line
                            (replacing v:val with the current line), and paste the
                            resulting lines.

    ["x]g\p, ["x]g\P        Escape certain characters (global default /
                            overridable per buffer g:UnconditionalPaste_Escapes;
                            if none or multiple are configured query first, or
                            take [count] to choose among multiples) and paste.

    ["x]g\\p, ["x]g\\P      Escape the same characters as the last time and paste.

    ["x]gpp, ["x]gpP        Paste with the first decimal number found on or after
                            the current cursor column (or the overall first
                            number, if no such match, or the last number, if the
                            cursor is at the end of the line) incremented /
                            decremented by 1.
                            Do this [count] times, with each paste further
                            incremented / decremented.

    ["x]gPp, ["x]gPP        Paste with all decimal numbers incremented /
                            decremented by 1.
                            Do this [count] times, with each paste further
                            incremented / decremented.

    ["x]gup, ["x]guP        Paste with the first alphabetical character of the
                            first / [count] word(s) made lowercase.
    ["x]gUp, ["x]gUP        Paste with the first alphabetical character of the
                            first / [count] word(s) made uppercase.
    ["x]g~p, ["x]g~P        Paste with the first alphabetical character of the
                            first / [count] word(s) toggled in case.

    ["x]ghp, ["x]ghP        Paste with a queried combination of above mappings.
                            The algorithm is the 1 or 2-character string between
                            the g..p / g..P in the mappings. A [count] before
                            ghp applies to each algorithm, you can override /
                            supply a local [count], too.
                            EXAMPLES                                             *
                            - Uppercase a word and paste linewise:
                                ghpUc<Enter>
                            - Unjoin words and paste as quoted list:
                                ghpuj,"<Enter><Space><Enter>
                            - Paste line 3 times and indent:
                                ghp>3l<Enter>
                            Note: Not all combinations make sense or work
                            correctly.
    ["x]gHp, ["x]gHP        Paste with the previously queried combination of above
                            mappings again. Defaults to linewise indented paste
                            with empty lines around (gSp + g>p)
                            g:UnconditionalPaste_Combinations.

    CTRL-R CTRL-C {0-9a-z"%#*+/:.-}
                            Insert the contents of a register characterwise
                            (newline characters and indent are flattened to
                            spaces).
                            If you have options like 'textwidth', 'formatoptions',
                            or 'autoindent' set, this will influence what will be
                            inserted.
                            Note: If the command-line mapping aborts
                            the command line, try defining
                                :cnoremap <C-c> <C-c>
                            or redefine the mapping.
    CTRL-R , {0-9a-z"%#*+/:.-}
                            Insert the contents of a register characterwise, with
                            each line delimited by ", " instead of the newline
                            (and indent).
    CTRL-R CTRL-Q {0-9a-z"%#*+/:.-}
                            Query for a separator string, then insert the contents
                            of a register characterwise, with each line delimited
                            by it. Like gqp, but in insert mode.

    CTRL-R CTRL-Q CTRL-Q {0-9a-z"%#*+/:.-}
                            Insert the contents of a register characterwise, with
                            each line delimited by the previously queried (gqp,
                            i_CTRL-R_CTRL-Q) separator string.

    CTRL-R CTRL-Q CTRL-G {0-9a-z"%#*+/:.-}
    CTRL-R CTRL-Q CTRL-Q CTRL-G CTRL-G {0-9a-z"%#*+/:.-}
                            Like CTRL-R CTRL-Q / CTRL-R CTRL-Q CTRL-Q, but keep
                            indent and surrounding whitespace as-is; just join the
                            lines with the separator (and prefix / suffix).

    CTRL-R CTRL-U {0-9a-z"%#*+/:.-}
                            Query for a separator pattern, un-join the contents of
                            a register, then insert it linewise.

    CTRL-R CTRL-U CTRL-U {0-9a-z"%#*+/:.-}
                            Un-join the contents of a register on the previously
                            queried (gujp, i_CTRL_R_CTRL-U) pattern, then
                            insert it linewise.

    CTRL-R CTRL-\ {0-9a-z"%#*+/:.-}
                            Escape certain characters (global default /
                            overridable per buffer g:UnconditionalPaste_Escapes;
                            if none or multiple are configured query first) and
                            insert.
    CTRL-R CTRL-\ CTRL-\ {0-9a-z"%#*+/:.-}
                            Escape the same characters as the last time and
                            insert.

    CTRL-R ~ {0-9a-z"%#*+/:.-}
                            Insert the contents of a register, toggling the case
                            of the first alphabetical character of the first word.
                            Like g~p / g~p, but in insert mode.

    CTRL-R CTRL-H {0-9a-z"%#*+/:.-}
                            Query for a combination of UnconditionalPaste
                            mappings, apply those to the contents of the register,
                            and insert the result.

    CTRL-R CTRL-H CTRL-H {0-9a-z"%#*+/:.-}
                            Apply the last queried combination of
                            UnconditionalPaste mappings to the contents of the
                            register again, and insert the result.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-UnconditionalPaste
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim UnconditionalPaste*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.026 or
  higher.
- repeat.vim ([vimscript #2136](http://www.vim.org/scripts/script.php?script_id=2136)) plugin (optional)
- AlignFromCursor.vim plugin ([vimscript #4155](http://www.vim.org/scripts/script.php?script_id=4155)), version 2.02 or higher
  (optional).

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

The default separator string for the gQBp mapping is a <Tab> character; to
preset another one (it will be overridden by gqbp), use:

    let g:UnconditionalPaste_Separator = 'text'

The default separator string for the gQp and i\_CTRL-R\_CTRL-Q\_CTRL-Q
mappings is a <Tab> character; to preset another one (it will be overridden by
gqp and i\_CTRL-R\_CTRL-Q), use:

    let g:UnconditionalPaste_JoinSeparator = 'text'

The default separator pattern for the gUJp and i\_CTRL-R\_CTRL-U\_CTRL-U
mappings matches any whitespace and newlines (i.e. it will get rid of empty
lines); to preset another one (it will be overridden by gujp and
i\_CTRL-R\_CTRL-U), use:

    let g:UnconditionalPaste_UnjoinSeparatorPattern = '-'

The default pattern for the gRp and gR!p mappings filter out
whitespace-only lines; to preset another one (will be overridden by grp /
gr!p), use:

    let g:UnconditionalPaste_GrepPattern = 'pattern'
    let g:UnconditionalPaste_InvertedGrepPattern = 'pattern'

The g>p / g>P mappings uses the AlignFromCursor.vim plugin's
functionality (if installed) to only affect the whitespace between the
original text and the pasted line. If you want to always :retab! all the
whitespace in the entire line, disable this via:

    let g:UnconditionalPaste_IsFullLineRetabOnShift = 1

By default, the g,ap, g,op, and g,np mappings use a comma immediately
before the coordinating conjunction (also known as "Oxford comma"; unless
exactly two lines are pasted); to turn this off:

    let g:UnconditionalPaste_IsSerialComma = 0

By default, the g\p and i\_CTRL-R\_CTRL-\ mappings escape backslashes. You
can change that (e.g. to also escape double quotes), or add more variants:

    let g:UnconditionalPaste_Escapes = [{
    \   'name': 'dquote',
    \   'pattern': '[\"]',
    \   'replacement': '\\&'
    \}, ...]

Each configuration object attributes is optional; alternatively, you can also
specify an expression (using v:val), or a Funcref that takes and returns a
String:

    let g:UnconditionalPaste_Escapes = [
    \   {'Replacer': 'tr(v:val, "o", "X")'},
    \   {'Replacer': function('MyReplacer')},
    \...]

The buffer-local b:UnconditionalPaste\_Escapes overrides that for particular
buffers (filetypes if placed in a ftplugin).

This stores the last replacement used for g\\p and i\_CTRL\_R\_CTRL-\.
It is initialized with the first escape from the above configuration / entered
/ selected escape.

The default combination used for the gHp and i\_CTRL-R\_CTRL-H\_CTRL-H
mappings. Must be a List of 1 or 2-character strings between the g..p / g..P
in the mappings; best obtained by selecting the desired algorithms via ghp
once and then grabbing the variable value:

    let g:UnconditionalPaste_Combinations = ['U', ',"', 's']

If you want to use different mappings (e.g. starting with <Leader>), map your
keys to the <Plug>UnconditionalPaste... mapping targets _before_ sourcing this
script (e.g. in your vimrc):

    nmap <Leader>Pc <Plug>UnconditionalPasteCharBefore
    nmap <Leader>pc <Plug>UnconditionalPasteCharAfter
    nmap <Leader>Pj <Plug>UnconditionalPasteJustJoinedBefore
    nmap <Leader>pj <Plug>UnconditionalPasteJustJoinedAfter
    nmap <Leader>Pl <Plug>UnconditionalPasteLineBefore
    nmap <Leader>pl <Plug>UnconditionalPasteLineAfter
    nmap <Leader>Pb <Plug>UnconditionalPasteBlockBefore
    nmap <Leader>pb <Plug>UnconditionalPasteBlockAfter
    nmap <Leader>Pi <Plug>UnconditionalPasteIndentedBefore
    nmap <Leader>pi <Plug>UnconditionalPasteIndentedAfter
    nmap <Leader>Pm <Plug>UnconditionalPasteMoreIndentBefore
    nmap <Leader>pm <Plug>UnconditionalPasteMoreIndentAfter
    nmap <Leader>Pl <Plug>UnconditionalPasteLessIndentBefore
    nmap <Leader>pl <Plug>UnconditionalPasteLessIndentAfter
    nmap <Leader>P> <Plug>UnconditionalPasteShiftedBefore
    nmap <Leader>p> <Plug>UnconditionalPasteShiftedAfter
    nmap <Leader>P# <Plug>UnconditionalPasteCommentedBefore
    nmap <Leader>p# <Plug>UnconditionalPasteCommentedAfter
    nmap <Leader>Ps <Plug>UnconditionalPasteSpacedBefore
    nmap <Leader>ps <Plug>UnconditionalPasteSpacedAfter
    nmap <Leader>PB <Plug>UnconditionalPasteJaggedBefore
    nmap <Leader>pB <Plug>UnconditionalPasteJaggedAfter
    nmap <Leader>Pd <Plug>UnconditionalPasteDelimitedBefore
    nmap <Leader>pd <Plug>UnconditionalPasteDelimitedAfter
    nmap <Leader>PD <Plug>UnconditionalPasteRecallDelimitedBefore
    nmap <Leader>pD <Plug>UnconditionalPasteRecallDelimitedAfter
    nmap <Leader>P, <Plug>UnconditionalPasteCommaBefore
    nmap <Leader>p, <Plug>UnconditionalPasteCommaAfter
    nmap <Leader>P' <Plug>UnconditionalPasteCommaSingleQuoteBefore
    nmap <Leader>p' <Plug>UnconditionalPasteCommaSingleQuoteAfter
    nmap <Leader>P" <Plug>UnconditionalPasteCommaDoubleQuoteBefore
    nmap <Leader>p" <Plug>UnconditionalPasteCommaDoubleQuoteAfter
    nmap <Leader>Pq <Plug>UnconditionalPasteQueriedBefore
    nmap <Leader>pq <Plug>UnconditionalPasteQueriedAfter
    nmap <Leader>PQ <Plug>UnconditionalPasteRecallQueriedBefore
    nmap <Leader>pQ <Plug>UnconditionalPasteRecallQueriedAfter
    nmap <Leader>Pgq <Plug>UnconditionalPasteQueriedJoinedBefore
    nmap <Leader>pgq <Plug>UnconditionalPasteQueriedJoinedAfter
    nmap <Leader>PgQ <Plug>UnconditionalPasteRecallJoinedQueriedBefore
    nmap <Leader>pgQ <Plug>UnconditionalPasteRecallJoinedQueriedAfter
    nmap <Leader>Puj <Plug>UnconditionalPasteUnjoinBefore
    nmap <Leader>puj <Plug>UnconditionalPasteUnjoinAfter
    nmap <Leader>PUJ <Plug>UnconditionalPasteRecallUnjoinBefore
    nmap <Leader>pUJ <Plug>UnconditionalPasteRecallUnjoinAfter
    nmap <Leader>Pr <Plug>UnconditionalPasteGrepBefore
    nmap <Leader>pr <Plug>UnconditionalPasteGrepAfter
    nmap <Leader>P! <Plug>UnconditionalPasteInvertedGrepBefore
    nmap <Leader>p! <Plug>UnconditionalPasteInvertedGrepAfter
    nmap <Leader>PR <Plug>UnconditionalPasteRecallGrepBefore
    nmap <Leader>pR <Plug>UnconditionalPasteRecallGrepAfter
    nmap <Leader>P1 <Plug>UnconditionalPasteRecallInvertedGrepBefore
    nmap <Leader>p1 <Plug>UnconditionalPasteRecallInvertedGrepAfter
    nmap <Leader>Pe <Plug>UnconditionalPasteExpressionBefore
    nmap <Leader>pe <Plug>UnconditionalPasteExpressionAfter
    nmap <Leader>PE <Plug>UnconditionalPasteRecallExpressionBefore
    nmap <Leader>pE <Plug>UnconditionalPasteRecallExpressionAfter
    nmap <Leader>Px <Plug>UnconditionalPasteEscapeBefore
    nmap <Leader>px <Plug>UnconditionalPasteEscapeAfter
    nmap <Leader>PX <Plug>UnconditionalPasteRecallEscapeBefore
    nmap <Leader>pX <Plug>UnconditionalPasteRecallEscapeAfter
    nmap <Leader>Pp <Plug>UnconditionalPastePlusBefore
    nmap <Leader>pp <Plug>UnconditionalPastePlusAfter
    nmap <Leader>PP <Plug>UnconditionalPasteGPlusBefore
    nmap <Leader>pP <Plug>UnconditionalPasteGPlusAfter
    nmap <Leader>Pu <Plug>UnconditionalPasteLowercaseBefore
    nmap <Leader>pu <Plug>UnconditionalPasteLowercaseAfter
    nmap <Leader>PU <Plug>UnconditionalPasteUppercaseBefore
    nmap <Leader>pU <Plug>UnconditionalPasteUppercaseAfter
    nmap <Leader>Ph <Plug>UnconditionalPasteCombinatorialBefore
    nmap <Leader>ph <Plug>UnconditionalPasteCombinatorialAfter
    nmap <Leader>PH <Plug>UnconditionalPasteRecallCombinatorialBefore
    nmap <Leader>pH <Plug>UnconditionalPasteRecallCombinatorialAfter

    imap <C-G>c <Plug>UnconditionalPasteCharI
    imap <C-G>, <Plug>UnconditionalPasteCommaI
    imap <C-G>q <Plug>UnconditionalPasteQueriedI
    imap <C-G>Q <Plug>UnconditionalPasteRecallQueriedI
    imap <C-G>j <Plug>UnconditionalPasteQueriedJoinedI
    imap <C-G>J <Plug>UnconditionalPasteRecallQueriedJoinedI
    imap <C-G>u <Plug>UnconditionalPasteUnjoinI
    imap <C-G>U <Plug>UnconditionalPasteRecallUnjoinI
    imap <C-G>x <Plug>UnconditionalPasteEscapeI
    imap <C-G>X <Plug>UnconditionalPasteRecallEscapeI
    imap <C-G>~ <Plug>UnconditionalPasteTogglecaseI
    imap <C-G>h <Plug>UnconditionalPasteCombinatorialI
    imap <C-G>H <Plug>UnconditionalPasteRecallCombinatorialI

    cmap <C-G>c <Plug>UnconditionalPasteCharI
    cmap <C-G>, <Plug>UnconditionalPasteCommaI
    cmap <C-G>q <Plug>UnconditionalPasteQueriedI
    cmap <C-G>Q <Plug>UnconditionalPasteRecallQueriedI
    cmap <C-G>j <Plug>UnconditionalPasteQueriedJoinedI
    cmap <C-G>J <Plug>UnconditionalPasteRecallQueriedJoinedI
    cmap <C-G>u <Plug>UnconditionalPasteUnjoinI
    cmap <C-G>U <Plug>UnconditionalPasteRecallUnjoinI
    cmap <C-G>x <Plug>UnconditionalPasteEscapeI
    cmap <C-G>X <Plug>UnconditionalPasteRecallEscapeI
    cmap <C-G>~ <Plug>UnconditionalPasteTogglecaseI
    cmap <C-G>h <Plug>UnconditionalPasteCombinatorialI
    cmap <C-G>H <Plug>UnconditionalPasteRecallCombinatorialI

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-UnconditionalPaste/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 4.30    RELEASEME
- ENH: Add gHp mapping for repeating the same previously queried combination
  and a configurable preset g:UnconditionalPaste\_Combinations.
- ENH: Add i\_CTRL-R\_CTRL-H / c\_CTRL-R\_CTRL-H mappings for ghp and
  i\_CTRL-R\_CTRL-H\_CTRL-H / c\_CTRL-R\_CTRL-H\_CTRL-H for gHp. As only some paste
  variants are offered in insert and command-line modes, these allow to use
  any (working) variant there, too, and any combinations of them.
- BUG: Empty line check in gSp does not account for a closed fold under cursor
  and wrongly considers the current line within the fold instead of the first
  / last folded line.

##### 4.20    24-Jan-2018
- Add JustJoined (gcgp) and QueriedJoined (gqgp, <C-q><C-g>) variants of gcp
  and gqp that keep indent and surrounding whitespace as-is.
- CHG: Insert and command-line mode <Plug> mappings now have a trailing I, to
  resolve the ambiguity between <Plug>UnconditionalPasteQueried and
  <Plug>UnconditionalPasteQueriedJoined. !!!\* Please update any insert- and
  command-line mode mapping customization. !!!\*
- Add CommaAnd (g,ap), CommaOr (g,op), and CommaNor (g,np) variants of g,p.
- Add Escape (g\p, i\_CTRL-R\_CTRL-\) and RecallEscape (g\\p,
  i\_CTRL-R\_CTRL-\\_CTRL-\) mappings to perform escaping of certain characters
  before pasting / inserting.

##### 4.10    23-Dec-2016
- Add grp / gr!p / gRp / gR!p mappings that include / exclude lines matching
  queried / recalled pattern, defaulting (both variants) to include only
  non-empty lines.
- Add g=p / g==p mappings that process lines through a queried / recalled Vim
  expression.
- ENH: In ghp query, offer help on the mnemonics by pressing ?.
- ENH: Make gqp also support 5-element
  {prefix}^M{element-prefix}^M{separator}^M{element-suffix}^M{suffix} in
  addition to the 3-element one.
  __You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.026!__

##### 4.00    09-Aug-2016
- Establish hard dependency on ingo-library. __You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.024 (or higher)!__
- BUG: Escaped characters like \n are handled inconsistently in gqp: resolved
  as {separator}, taken literally in {prefix} and {suffix}. Use
  ingo#cmdargs#GetUnescapedExpr() to resolve them (also for gqbp, which only
  supports {separator}).
- ENH: If there's only a single line to paste and no [count] with the
  blockwise commands (gbp, gBp, gqbq, gQBp), first query about a separator
  pattern and un-join the register contents. Otherwise, these variants don't
  make much sense (and for the corner cases, a count of 1 can be supplied).
- CHG: Split off gSp from gsp; the latter now flattens line(s) like gcp,
  whereas the new gSp forces linewise surrounding with empty lines. I found
  that I often dd a line in order to append it to another line with a space
  in between.
- CHG: Change gup / gUp to gujp / gUJp and add gup / gUp to lower / uppercase
  the first character of the register
- Need to use temporary default register also for the built-in read-only
  registers {:%.}.
- FIX: Vim error on CTRL-R ... mappings incorrectly inserted "0". Need to
  return '' from :catch.
- Add ghp / ghP combinatorial type that queries and then sequentially applies
  multiple algorithms.

##### 3.10    23-Dec-2014
- Add g,'p and g,"p variants of g,p.
- ENH: Allow to specify prefix and suffix when querying for the separator
  string in gqp and i\_CTRL-R\_CTRL-Q.

##### 3.03    03-Dec-2014
- BUG: gsp / gsP border check adds spaces on both sides when there's a single
  character in line (like when there's a completely empty line, where this
  would be correct). Differentiate between empty and single-char line and then
  clear the isAtStart / isAtEnd flag not in the direction of the paste.

##### 3.02    19-Jun-2014
- CHG: Change default mappings of gdp and gDp to gqbp and gQBp, respectively,
  to avoid slowing down the built-in gd and gD commands with a wait for
  the mapping timeout. Though the new defaults are one keystroke longer, they
  are a better mnemonic (combining gqp and gBp), and this is a rather obscure
  mapping, anyway.

##### 3.01    23-May-2014
- For gsp, remove surrounding whitespace (characterwise) / empty lines
  (linewise) before adding the spaces / empty lines. This ensures a more
  dependable and deterministic DWIM behavior.

##### 3.00    24-Mar-2014
- ENH: Extend CTRL-R insert mode mappings to command-line mode.
- When doing gqp / q,p of a characterwise or single line, put the separator in
  front (gqp) / after (gqP); otherwise, the mapping is identical to normal p /
  P and therefore worthless.
- Add g#p mapping to apply 'commentstring' to each indented linewise paste.
- Add gsp mapping to paste with [count] spaces / empty lines around the
  register contents.
- Add gdp / gDp mappings to paste as a minimal fitting block with (queried /
  recalled) separator string, with special cases at the end of leading indent
  and at the end of the line.
- Add gBp mapping to paste as a minimal fitting block with jagged right edge,
  a separator-less variant of gDp.
- Add g>p mapping to paste shifted register contents.
- Add g]]p and g[[p mappings to paste like with g]p, but with more / less
  indent.

##### 2.21    23-Apr-2013
- FIX: In gpp and gPp, keep leading zeros when incrementing the number.
- FIX: In gpp and gPp, do not interpret leading zeros as octal numbers when
  incrementing.

##### 2.20    18-Mar-2013
- ENH: gpp also handles multi-line pastes. A number (after the corresponding
  column) is incremented in every line. If there are no increments this way,
  fall back to replacement of the first occurrence.
- ENH: Add gPp / gPP mappings to paste with all numbers incremented /
  decremented.
- ENH: Add g]p / g]P mappings to paste linewise with adjusted indent. Thanks
  to Gary Fixler for the suggestion.

##### 2.10    22-Dec-2012
- ENH: Add gpp / gpP mappings to paste with one number (which depending on the
  current cursor position) incremented / decremented.
- FIX: For characterwise pastes with a [count], the multiplied pastes must be
  joined with the desired separator, not just plainly concatenated.
- FIX: Don't lose the original [count] given when repeating the mapping.
- FIX: Do not re-query on repeat of the mapping.

##### 2.00    05-Dec-2012
- ENH: Add g,p / gqp / gQp mappings to paste lines flattened with comma,
  queried, or recalled last used delimiter.
- ENH: Add gup / gUp mappings to paste unjoined register with queried or
  recalled last used delimiter pattern.
- ENH: Add CTRL-R CTRL-C mapping to insert register contents characterwise
  (flattened) from insert mode, and similar insert mode mappings for the other
  new mappings.
- CHG: Flatten all whitespace and newlines before, after, and around lines
  when pasting characterwise or joined.

##### 1.22    04-Dec-2012
- BUG: When repeat.vim is not installed, the mappings do nothing. Need to
  :execute the :silent! call of repeat.vim to avoid that the remainder of the
  command line is aborted together with the call.
- Using separate autoload script to help speed up Vim startup.

##### 1.21    02-Dec-2011
- ENH: When pasting a blockwise register as lines, strip all trailing
  whitespace. This is useful when cutting a block of text from a column-like
  text and pasting as new lines.
- ENH: When pasting a blockwise register as characters, flatten and shrink all
  trailing whitespace to a single space.

##### 1.20    30-Sep-2011
- BUG: Repeat always used the unnamed register. Add register registration to
enhanced repeat.vim plugin. This also handles repetition when used together
with the expression register "=. Requires a so far inofficial update to
repeat.vim version 1.0 (that hopefully makes it into upstream), which is
available at https://github.com/inkarkat/vim-repeat/zipball/1.0ENH1

##### 1.11    06-Jun-2011
- ENH: Support repetition of mappings through repeat.vim.

##### 1.10    12-Jan-2011
- Incorporated suggestions by Peter Rincker (thanks for the patch!):
- Made mappings configurable via the customary <Plug> mappings.
- Added mappings gbp, gbP for blockwise pasting.
- Now requires Vim version 7.0 or higher.

##### 1.00    10-Dec-2010
- Published, prompted by a related question on reddit.

##### 0.01    10-Apr-2006
- Started development, based on vimtip #1199 by cory.

------------------------------------------------------------------------------
Copyright: (C) 2006-2018 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat <ingo@karkat.de>
