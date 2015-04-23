" moveCursor.vim "{{{1
" Last Update: Apr 23, Thu | 21:30:27 | 2015

" Version: 0.7.1-nightly
" License: GPLv3
" Author: Bozar

" script variables
" s:LineNr . [id]
" s:PosCurrent
" s:PosTop

function moveCursor#DetectLineNr(id,...) "{{{2

    let l:LineNr = 's:LineNr' . a:id

    if !exists(l:LineNr)
        if exists('a:1') && a:1 ># 0
            echom 'ERROR:' . ' ' . l:LineNr .
            \ " doesn't exist in moveCursor.vim!"
        endif
        return 1
    else
        return 2
    endif

endfunction "}}}2

function moveCursor#DetectMark(id,...) "{{{2

    let l:mark = "'" . a:id

    if line(l:mark) <# 1 ||
    \ line(l:mark) ># line('$')
        if exists('a:1') && a:1 ># 0
            echom 'ERROR: Mark' . ' ' . l:mark .
            \ ' not found!'
        endif
        return 1
    else
        return 2
    endif

    " try & catch will move cursor to the specific
    " mark, which might cause trouble

    "try
    "    execute l:mark
    "    "'<
    "    catch /\v^Vim%(\(\a+\))=:(E19|E20)/
    "    echom 'error'
    "    return 1
    "endtry
    "return 2

endfunction "}}}2

function moveCursor#DetectFold(...) "{{{2

    if foldlevel('.') <# 1
        if exists('a:1') && a:1 ># 0
            echom 'ERROR: Fold not found!'
        endif
        return 1
    else
        return 2
    endif

endfunction "}}}2

function moveCursor#GotoParaBegin() "{{{2

    if getline('.') ==# ''
        execute 'normal! }{+1'
    elseif getline("'{") !=# ''
        execute 'normal! {'
    else
        execute 'normal! {+1'
    endif

endfunction "}}}2

function moveCursor#GotoParaEnd() "{{{2

    if getline("'}") !=# ''
        execute 'normal! }'
    else
        execute 'normal! }-1'
    endif

endfunction "}}}2

function moveCursor#GotoFoldBegin() "{{{2

    let l:line = line('.')
    let l:level = foldlevel('.')

    execute 'normal! [z'
    if foldlevel('.') !=# l:level
        execute l:line
    endif

endfunction "}}}2

function moveCursor#KeepPos(when) "{{{2

    if a:when ==# 0
        let s:PosCurrent = getpos('.')
        let s:PosTop = getpos('w0')
        call setpos('.',s:PosCurrent)
    elseif a:when ==# 1
        call setpos('.',s:PosTop)
        execute 'normal! zt'
        call setpos('.',s:PosCurrent)
    endif

endfunction "}}}2

function moveCursor#SetLineNr(expr,id) "{{{2

    if type(a:expr) ==# type('string')
        execute 'let s:LineNr' . a:id . '=' .
        \ line(a:expr)
    elseif type(a:expr) ==# type(1)
        execute 'let s:LineNr' . a:id . '=' .
        \ a:expr
    endif

endfunction "}}}2

function moveCursor#TakeLineNr(from,to,...) "{{{2

    execute 'let l:from = s:LineNr' . a:from
    if a:to !=# ''
        execute 'let l:to = s:LineNr' . a:to
    endif

    if exists('a:1')
        let l:from = l:from + a:1
    endif
    if exists('a:2')
        let l:to = l:to + a:2
    endif

    if exists('l:to')
        let l:range = l:from . ',' . l:to
    elseif !exists('l:to')
        let l:range = l:from
    endif

    return l:range

endfunction "}}}2

function moveCursor#SetLineJKPara(...) "{{{2

    call moveCursor#GotoParaBegin()
    if exists('a:1')
        call moveCursor#SetLineNr('.',a:1)
    else
        call moveCursor#SetLineNr('.','J')
    endif

    call moveCursor#GotoParaEnd()
    if exists('a:2')
        call moveCursor#SetLineNr('.',a:2)
    else
        call moveCursor#SetLineNr('.','K')
    endif

endfunction "}}}2

function moveCursor#SetLineJKFold(...) "{{{2

    call moveCursor#GotoFoldBegin()
    if exists('a:1')
        call moveCursor#SetLineNr('.',a:1)
    else
        call moveCursor#SetLineNr('.','J')
    endif

    execute 'normal! ]z'
    if exists('a:2')
        call moveCursor#SetLineNr('.',a:2)
    else
        call moveCursor#SetLineNr('.','K')
    endif

endfunction "}}}2

function moveCursor#SetLineJKWhole(...) "{{{2

    if exists('a:1')
        call moveCursor#SetLineNr(1,a:1)
    else
        call moveCursor#SetLineNr(1,'J')
    endif

    if exists('a:2')
        call moveCursor#SetLineNr('$',a:2)
    else
        call moveCursor#SetLineNr('$','K')
    endif

endfunction "}}}2

" vim: set fdm=marker fdl=20 tw=50 "}}}1
