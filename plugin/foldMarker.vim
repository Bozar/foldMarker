" foldMarker.vim "{{{1
" Last Update: May 12, Tue | 15:16:50 | 2015

" Version: 1.1.0-nightly
" License: GPLv3
" Author: Bozar

" STATUS:
" - add new features

" DONE:
" - fix: fold marker pattern
" - add: move fold head
" - add: creat fold marker without fold level
" - delete fold markers
" - use existing fold level

" WORKING:
" - accept command range other than `'<` and `'>`

" TODO:

" load once
if !exists('g:loaded_foldMarker')
    let g:loaded_foldMarker = 0
endif
if g:loaded_foldMarker ># 0
    finish
endif
let g:loaded_foldMarker = 1

" nocpoptions
let s:Save_cpo = &cpoptions
set cpoptions&vim

" BEGIN
" ==============================

let s:Title = 'FOLDMARKER'

function! s:DetectFoldMethod() "{{{2

    if &foldmethod !=# 'marker'
        echom "ERROR: 'foldmethod' is NOT" .
        \ " 'marker'!"
        return 1
    endif

endfunction "}}}2

function! s:LoadVars() "{{{2

    let s:Bra = substitute(
    \ &foldmarker,'\v(.*)(,.*)','\1','')
    let s:Ket = substitute(
    \ &foldmarker,'\v(.*,)(.*)','\2','')

    let s:FoldBegin = '\v^' .
    \ '(.*)\s(\S{-})' .
    \ '\V' . s:Bra . '\v(\d{0,2})\s*$'
    let s:FoldEnd = '\v^' . '(' .
    \ '((.*)\s(\S{-}))' . '|' .
    \ '(\S{-})' . ')' .
    \ '\V' . s:Ket . '\v(\d{0,2})\s*$'
    "let s:FoldEnd = '\v^(.*)' .
    "\ '\V' . s:Ket . '\v(\d{0,2})\s*$'

    if !exists('g:MoveFold_FoldMarker')
        let s:MoveFold = 0
    elseif g:MoveFold_FoldMarker =~# '^\d$'
    \ && g:MoveFold_FoldMarker >=# 0
    \ && g:MoveFold_FoldMarker <=# 3
        let s:MoveFold = g:MoveFold_FoldMarker
    else
        let s:MoveFold = 0
    endif

endfunction "}}}2

function! s:MoveFold(when,where) "{{{2

    if a:where ==# 'line' ||
    \ a:where ==# 'below' ||
    \ a:where ==# 'sur'
        let l:keep = 0
    elseif a:where ==# 'above'
        let l:keep = 1
    endif

    call moveCursor#KeepPos(a:when,l:keep)

    if a:when !=# 1
        return 1
    endif

    if s:MoveFold ==# 0
        execute 'normal! ]z[z'
    elseif s:MoveFold ==# 1
        execute 'normal! zt'
    elseif s:MoveFold ==# 2
        execute 'normal! zz'
    elseif s:MoveFold ==# 3
        execute 'normal! ]zzb[z'
    endif

endfunction "}}}2

function! s:ExpandFold(when) "{{{2

    if a:when ==# 0
        let s:FoldLevel = &foldlevel
        let &foldlevel = 20
    endif
    if a:when ==# 1
        let &foldlevel = s:FoldLevel
    endif

endfunction "}}}2

function! s:GetFoldPrefix() "{{{2

    let l:pos = getpos('.')
    if moveCursor#DetectFold() ==# 2
        call moveCursor#GotoFoldBegin()
        if getline('.') =~# s:FoldBegin
            let s:Prefix =
            \ substitute(getline('.'),s:FoldBegin,
            \ '\2','')
        else
            let s:Prefix = ''
        endif
    elseif moveCursor#DetectFold() ==# 1
        let s:Prefix = ''
    endif
    call setpos('.',l:pos)

endfunction "}}}2

function! s:CreatMarker(where) "{{{2

    let l:begin = ' ' . s:Prefix . s:Bra
    let l:end = s:Prefix . s:Ket

    " before current line
    if a:where ==# 0
        execute 's/^/' . s:Title . l:begin .
        \ '\r\r\r' . l:end . '\r/'
        -1
    endif

    " after current line
    if a:where ==# 1
        execute 's/$/\r' . s:Title . l:begin .
        \ '\r\r\r' . l:end . '/'
    endif

    " wrap visual area
    if a:where ==# 2
        if getline("'<") =~# '\v^\s*$'
            execute "'<" . 's/$/' . s:Title .
            \ l:begin . '/'
        else
            execute "'<" . 's/$/' . l:begin . '/'
        endif
        if getline("'>") =~# '\v^\s*$'
            execute "'>" . 's/$/' . l:end . '/'
        else
            execute "'>" . 's/$/' . ' ' . l:end .
            \ '/'
        endif
    endif

endfunction "}}}2

function! s:CreatLevel(mode,creat) "{{{2

    " new search pattern
    let l:numBegin =
    \ substitute(s:FoldBegin,'{0,2}','{1,2}','')
    let l:noNumBegin =
    \ substitute(s:FoldBegin,'{0,2}','{0}','')
    let l:numEnd =
    \ substitute(s:FoldEnd,'{0,2}','{1,2}','')
    let l:noNumEnd =
    \ substitute(s:FoldEnd,'{0,2}','{0}','')

    " command range
    if a:mode ==# 'n'
        call moveCursor#SetLineJKFold()
    elseif a:mode ==# 'v'
        call moveCursor#SetLineNr("'<",'J')
        call moveCursor#SetLineNr("'>",'K')
    endif

    " get relative fold level
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if a:creat ==# 2 && search(l:numBegin,'cW',
    \ moveCursor#TakeLineNr('K',''))
        call moveCursor#SetLineNr('.','H')
        let l:newLevel =
        \ substitute(getline('.'),l:numBegin,
        \ '\3','')
        let l:relative = 1
    else
        let l:relative = 0
    endif

    " always delete fold level, begin
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if search(l:numBegin,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:numBegin .
        \ '/s//\1 \2' . s:Bra . '/'
    endif

    " always delete fold level, end
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if search(l:numEnd,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:numEnd .
        \ '/s//\3' . s:Ket . '/'
    endif

    " creat absolute fold level, begin
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if (a:creat ==# 1 ||
    \ (a:creat ==2 && l:relative ==# 0)) &&
    \ search(l:noNumBegin,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:noNumBegin .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    endif

    " creat absolute fold level, end
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if (a:creat ==# 1 ||
    \ (a:creat ==2 && l:relative ==# 0)) &&
    \ search(l:noNumEnd,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:noNumEnd .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    endif

    " return, unless creat relative level
    if a:creat ==# 2 && l:relative ==# 1
        let l:return = 0
    else
        let l:return = 1
    endif
    if l:return ==# 1
        return 1
    endif

    " creat relative fold level, J-H, begin
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if search(l:noNumBegin,'cnW',
    \ moveCursor#TakeLineNr('H',''))
        execute moveCursor#TakeLineNr('J','H') .
        \ 'g/' . l:noNumBegin .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    endif

    " creat relative fold level, J-H, end
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if search(l:noNumEnd,'cnW',
    \ moveCursor#TakeLineNr('H',''))
        execute moveCursor#TakeLineNr('J','H') .
        \ 'g/' . l:noNumEnd .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    endif

    " creat relative fold level, H, begin
    execute moveCursor#TakeLineNr('H','') .
    \ 's/\v\d+$/' . l:newLevel . '/'

    " creat relative fold level, H-K, begin
    execute moveCursor#TakeLineNr('H','',1)
    if line('.') <=# moveCursor#TakeLineNr('K','')
    \ && search(l:noNumBegin,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('H','K') .
        \ 'g/' . l:noNumBegin .
        \ '/s/$/\=foldlevel(".")/'
    endif

    " creat relative fold level, H-K, end
    execute moveCursor#TakeLineNr('H','',1)
    if line('.') <=# moveCursor#TakeLineNr('K','')
    \ && search(l:noNumEnd,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('H','K') .
        \ 'g/' . l:noNumEnd .
        \ '/s/$/\=foldlevel(".")/'
    endif

endfunction "}}}2

function! s:DeleteMarker(range) "{{{2

    call moveCursor#SetLineNr("'<",'J')
    call moveCursor#SetLineNr("'>",'K')

    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if search(s:FoldBegin,'cW',
    \ moveCursor#TakeLineNr('K',''))
        if a:range ==# 0
            execute 's/' . s:FoldBegin . '/\1/'
        elseif a:range ==# 1
            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' . s:FoldBegin . '/\1/'
        endif
    endif

    execute moveCursor#TakeLineNr('K','')
    normal! $
    if search(s:FoldEnd,'bcW',
    \ moveCursor#TakeLineNr('J',''))
        if a:range ==# 0
            execute 's/' . s:FoldEnd . '/\3/'
        elseif a:range ==# 1
            execute
            \ moveCursor#TakeLineNr('J','K') .
            \ 's/' . s:FoldEnd . '/\3/'
        endif
    endif

endfunction "}}}2

function! s:Help() "{{{2

    echom '------------------------------'
    echom s:ComName . ' [arg]'
    echom '------------------------------'
    echom 'lower case args: l/a/b/s/c/d/r/h'
    echom 'upper case args: L/A/B/S/C/-/R/-'
    echom '------------------------------'

    echom 'h: show (H)elp'
    echom '------------------------------'
    echom 'Create fold marker with(lower case' .
    \ ' args)'
    echom 'or without(upper case args) fold' .
    \ ' level...'
    echom '------------------------------'
    echom '[blank] or l/L: below current (L)ine'
    echom 'a/A: (A)bove current fold area'
    echom 'b/B: (B)elow current fold area'
    echom 's/S: (S)urround selected lines'
    echom '------------------------------'

    echom 'c: (C)reat absolute fold level(s)'
    echom 'C: (C)reat relative fold level(s)'
    echom 'd: (D)elete fold level(s)'
    echom '------------------------------'

    echom 'r: (R)emove the outermost fold' .
    \ ' marker(s)'
    echom 'R: (R)emove all fold marker(s)'
    echom '------------------------------'

endfunction "}}}2

" main function
function! s:FoldMarker(where,level,...) "{{{2

    if <sid>DetectFoldMethod() ==# 1
        return 1
    endif
    call <sid>LoadVars()
    call <sid>MoveFold(0,a:where)
    call <sid>ExpandFold(0)

    " move cursor to <line1>
    call moveCursor#SetLineNr(a:1,'J')
    call moveCursor#SetLineNr(a:2,'K')
    execute moveCursor#TakeLineNr('J','')

    call <sid>GetFoldPrefix()

    if a:where ==# 'line'
        call <sid>CreatMarker(1)
    endif

    if a:where ==# 'above'
        call moveCursor#GotoFoldBegin()
        call <sid>CreatMarker(0)
    endif

    if a:where ==# 'below'
        call moveCursor#GotoFoldBegin()
        normal! ]z
        call <sid>CreatMarker(1)
    endif

    " surround
    if a:where ==# 'sur'

        if line("'<") ==# line("'>")
            echom 'ERROR: Visual area only' .
            \ ' has one line!'
            call <sid>ExpandFold(1)
            return 2
        endif

        if getline(line("'<")) =~# s:FoldBegin ||
        \ getline(line("'<")) =~# s:FoldEnd ||
        \ getline(line("'>")) =~# s:FoldBegin ||
        \ getline(line("'>")) =~# s:FoldEnd
            echom 'ERROR: Visual area already' .
            \ ' has fold marker!'
            call <sid>ExpandFold(1)
            return 3
        endif

        call <sid>CreatMarker(2)

    endif

    call <sid>CreatLevel('n',a:level)
    call moveCursor#GotoFoldBegin()
    call <sid>ExpandFold(1)
    call <sid>MoveFold(1,a:where)

endfunction "}}}2

function! s:FoldLevel(creat,...) "{{{2

    if <sid>DetectFoldMethod() ==# 1
        return 1
    endif
    call <sid>LoadVars()
    call moveCursor#KeepPos(0,0)
    call <sid>ExpandFold(0)

    call <sid>CreatLevel('v',a:creat)

    call <sid>ExpandFold(1)
    call moveCursor#KeepPos(1,0,1)

endfunction "}}}2

function! s:Remove(range,...) "{{{2

    if <sid>DetectFoldMethod() ==# 1
        return 1
    endif
    call <sid>LoadVars()
    call moveCursor#KeepPos(0,0)
    call <sid>ExpandFold(0)

    call <sid>DeleteMarker(a:range)

    call <sid>ExpandFold(1)
    call moveCursor#KeepPos(1,0,1)

endfunction "}}}2

function! s:SelectFuns(...) "{{{2

    " a:1, <line1>
    " a:2, <line2>
    " a:3, <f-args>
    if !exists('a:3')
        call <sid>FoldMarker('line',1,a:1,a:2)
    elseif a:3 ==# 'l'
        call <sid>FoldMarker('line',1,a:1,a:2)
    elseif a:3 ==# 'a'
        call <sid>FoldMarker('above',1,a:1,a:2)
    elseif a:3 ==# 'b'
        call <sid>FoldMarker('below',1,a:1,a:2)
    elseif a:3 ==# 's'
        call <sid>FoldMarker('sur',1,a:1,a:2)

    elseif a:3 ==# 'L'
        call <sid>FoldMarker('line',0,a:1,a:2)
    elseif a:3 ==# 'A'
        call <sid>FoldMarker('above',0,a:1,a:2)
    elseif a:3 ==# 'B'
        call <sid>FoldMarker('below',0,a:1,a:2)
    elseif a:3 ==# 'S'
        call <sid>FoldMarker('sur',0,a:1,a:2)

    elseif a:3 ==# 'c'
        call <sid>FoldLevel(1,a:1,a:2)
    elseif a:3 ==# 'C'
        call <sid>FoldLevel(2,a:1,a:2)
    elseif a:3 ==# 'd'
        call <sid>FoldLevel(0,a:1,a:2)

    elseif a:3 ==# 'r'
        call <sid>Remove(0,a:1,a:2)
    elseif a:3 ==# 'R'
        call <sid>Remove(1,a:1,a:2)

    elseif a:3 ==# 'h'
        call <sid>Help()

    else
        return 1

    endif

endfunction "}}}2

function! s:Commands() "{{{2

    if exists('g:ComName_FoldMarker') &&
    \ g:ComName_FoldMarker !=# ''
        let s:ComName = g:ComName_FoldMarker
    elseif !exists(':FoldMarker')
        let s:ComName = 'FoldMarker'
    else
        let s:ComName = ''
    endif

    if s:ComName !=# ''
        execute 'command -range -nargs=?' . ' ' .
        \ s:ComName .
        \ ' call <sid>SelectFuns(' .
        \ '<line1>,<line2>,<f-args>)'
    else
        return 1
    endif

endfunction "}}}2

call <sid>Commands()

" END
" ==============================

" nocpoptions
let &cpoptions = s:Save_cpo
unlet s:Save_cpo

" vim: set fdm=marker fdl=20 tw=50 "}}}1
