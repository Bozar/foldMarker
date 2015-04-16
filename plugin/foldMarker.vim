" foldMarker.vim "{{{1
" Last Update: Apr 16, Thu | 21:43:33 | 2015

" Version: 0.9.3-nightly
" License: GPLv3
" Author: Bozar

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

function! s:DetectVisualBlock() "{{{2

    if line("'<") <# 1 ||
    \ line("'>") <# 1 ||
    \ line("'<") ># line('$') ||
    \ line("'>") ># line('$')
        echom 'ERROR: Visual block not found!'
        return 1
    endif

endfunction "}}}2

function! s:LoadVars() "{{{2

    let s:Bra =
    \ substitute(&foldmarker,'\v(.*)(,.*)','\1',
    \ '')
    let s:Ket =
    \ substitute(&foldmarker,'\v(.*,)(.*)','\2',
    \ '')

    let s:FoldBegin = '\v^(.*)\s(\S{-})' .
    \ '\M' . s:Bra . '\v(\d{0,2})\s*$'
    let s:FoldEnd = '\v^(.*)' .
    \ '\M' . s:Ket . '\v(\d{0,2})\s*$'

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

    " wrap visual block
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

    if a:mode ==# 'v' &&
    \ <sid>DetectVisualBlock() ==# 1
        return 1
    endif

    " new search pattern
    let l:numBegin =
    \ substitute(s:FoldBegin,'{0,2}','+','')
    let l:noNumBegin =
    \ substitute(s:FoldBegin,'{0,2}','{0}','')
    let l:numEnd =
    \ substitute(s:FoldEnd,'{0,2}','+','')
    let l:noNumEnd =
    \ substitute(s:FoldEnd,'{0,2}','{0}','')

    " command range
    if a:mode ==# 'n'
        call moveCursor#SetLineJKFold()
    elseif a:mode ==# 'v'
        call moveCursor#SetLineNr("'<",'J')
        call moveCursor#SetLineNr("'>",'K')
    endif

    " always delete fold level, begin
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if exists('a:creat') &&
    \ search(l:numBegin,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:numBegin .
        \ '/s//\1 \2' . s:Bra . '/'
    endif

    " always delete fold level, end
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if exists('a:creat') &&
    \ search(l:numEnd,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:numEnd .
        \ '/s//\1' . s:Ket . '/'
    endif

    " creat fold level, begin
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if a:creat ># 0 &&
    \ search(l:noNumBegin,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:noNumBegin .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    endif

    " creat fold level, end
    execute moveCursor#TakeLineNr('J','')
    normal! 0
    if a:creat ># 0 &&
    \ search(l:noNumEnd,'cnW',
    \ moveCursor#TakeLineNr('K',''))
        execute moveCursor#TakeLineNr('J','K') .
        \ 'g/' . l:noNumEnd .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    endif

endfunction "}}}2

function! s:Help() "{{{2

	echom '------------------------------'
	echom 'FoldMarker [args]'
	echom '------------------------------'
	echom 'Create new foldmarker...'
	echom '[blank] or l: after current (L)ine'
	echom 'a: (A)fter current fold block'
	echom 'b: (B)efore current fold block'
	echom 's: (S)urround selected lines'
	echom '------------------------------'
	echom 'c: (C)reat fold level'
	echom 'd: (D)elete fold level'
	echom '------------------------------'

endfunction "}}}2

" main function
function! s:FoldMarker(where) "{{{2

	if <sid>DetectFoldMethod() ==# 1
        return 1
    endif
    call <sid>LoadVars()
    call <sid>ExpandFold(0)
    call <sid>GetFoldPrefix()

    if a:where ==# 'line'
        call <sid>CreatMarker(1)
    endif

    if a:where ==# 'before'
        call moveCursor#GotoFoldBegin()
        call <sid>CreatMarker(0)
    endif

    if a:where ==# 'after'
        call moveCursor#GotoFoldBegin()
        normal! ]z
        call <sid>CreatMarker(1)
    endif

    if a:where ==# 'surround'

        if <sid>DetectVisualBlock() ==# 1
            call <sid>ExpandFold(1)
            return 2
        endif

        if line("'<") ==# line("'>")
            echom 'ERROR: Visual block only' .
            \ ' has one line!'
            call <sid>ExpandFold(1)
            return 3
        endif

        if getline(line("'<")) =~# s:FoldBegin ||
        \ getline(line("'<")) =~# s:FoldEnd ||
        \ getline(line("'>")) =~# s:FoldBegin ||
        \ getline(line("'>")) =~# s:FoldEnd
            echom 'ERROR: Visual block already' .
            \ ' has fold marker!'
            call <sid>ExpandFold(1)
            return 4
        endif

        call <sid>CreatMarker(2)

    endif

    call <sid>CreatLevel('n',1)
    normal! [z
    call <sid>ExpandFold(1)
    normal! zz

endfunction "}}}2

function! s:FoldLevel(creat) "{{{2

	if <sid>DetectFoldMethod() ==# 1
        return 1
    endif
    call <sid>LoadVars()
    call <sid>ExpandFold(0)

    if a:creat ==# 0
        call <sid>CreatLevel('v',0)
    elseif a:creat ==# 1
        call <sid>CreatLevel('v',1)
    endif

    call <sid>ExpandFold(1)

endfunction "}}}2

function! s:SelectFuns(...) "{{{2

	if !exists('a:1') || a:1 ==# 'l'
        call <sid>FoldMarker('line')
	elseif a:1 ==# 'b'
        call <sid>FoldMarker('before')
	elseif a:1 ==# 'a'
        call <sid>FoldMarker('after')
	elseif a:1 ==# 's'
        call <sid>FoldMarker('surround')
	elseif a:1 ==# 'd'
        call <sid>FoldLevel(0)
	elseif a:1 ==# 'c'
        call <sid>FoldLevel(1)
    else
        call <sid>Help()
    endif

endfunction "}}}2

function! s:Commands() "{{{2

	if !exists(':FoldMarker')
		command -range -nargs=? FoldMarker
        \ call <sid>SelectFuns(<f-args>)
    endif

endfunction "}}}2

call <sid>Commands()

" END
" ==============================

" nocpoptions
let &cpoptions = s:Save_cpo
unlet s:Save_cpo

" vim: set fdm=marker fdl=20 tw=50 "}}}1
