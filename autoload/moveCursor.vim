" moveCursor.vim
" Last Update: May 13, Wed | 13:06:55 | 2015

" Version: 0.7.1-nightly
" License: GPLv3
" Author: Bozar

" script variables
" s:LineNr . [id]
" s:PosOrigin
" s:PosTop
" s:PosBot

function moveCursor#DetectLineNr(id,...)
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
endfunction

function moveCursor#DetectMark(id,...)
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
endfunction

function moveCursor#DetectFold(...)
    if foldlevel('.') <# 1
        if exists('a:1') && a:1 ># 0
            echom 'ERROR: Fold not found!'
        endif
        return 1
    else
        return 2
    endif
endfunction

function moveCursor#GotoParaBegin()
    if getline('.') ==# ''
        execute 'normal! }{+1'
    elseif getline("'{") !=# ''
        execute 'normal! {'
    else
        execute 'normal! {+1'
    endif
endfunction

function moveCursor#GotoParaEnd()
    if getline("'}") !=# ''
        execute 'normal! }'
    else
        execute 'normal! }-1'
    endif
endfunction

function moveCursor#GotoFoldBegin()
    let l:line = line('.')
    let l:level = foldlevel('.')
    execute 'normal! [z'
    if foldlevel('.') !=# l:level
        execute l:line
    endif
endfunction

function moveCursor#KeepPos(when,...)
    " a:1 ==# 0, 'w0'
    " a:1 ==# 1, 'w$'
    " a:2 ># 0, get original cursor position

    if a:when ==# 0
        " get original cursor position
        let s:PosOrigin = getpos('.')
        " get position in current window
        if !exists('a:1') || a:1 ==# 0
            let s:PosTop = getpos('w0')
        elseif a:1 ==# 1
            let s:PosBot = getpos('w$')
        endif

    elseif a:when ==# 1
        " set position in current window
        let l:posCurrent = getpos('.')
        if !exists('a:1') || a:1 ==# 0
            call setpos('.',s:PosTop)
            execute 'normal! zt'
        elseif a:1 ==# 1
            call setpos('.',s:PosBot)
            execute 'normal! zb'
        endif
        call setpos('.',l:posCurrent)
        " set original cursor position
        if exists('a:2') && a:2 ># 0
            call setpos('.',s:PosOrigin)
        endif
    endif
endfunction

function moveCursor#SetLineNr(expr,id)
    if type(a:expr) ==# type('string')
        execute 'let s:LineNr' . a:id . '=' .
        \ line(a:expr)
    elseif type(a:expr) ==# type(1)
        execute 'let s:LineNr' . a:id . '=' .
        \ a:expr
    endif
endfunction

function moveCursor#TakeLineNr(from,to,...)
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
endfunction

function moveCursor#SetLineJKPara(...)
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
endfunction

function moveCursor#SetLineJKFold(...)
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
endfunction

function moveCursor#SetLineJKWhole(...)
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
endfunction

" vim: set fdm=indent fdl=20 tw=50
