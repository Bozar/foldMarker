" foldMarker.vim "{{{1
" Last Update: Apr 09, Thu | 11:39:04 | 2015

" Version: 0.8.0
" License: GPLv3
" Author: Bozar

let s:Title = 'FOLDMARKER'

function! s:DetectFoldMethod() "{{{2

	if &foldmethod !=# 'marker'
        echom "ERROR: 'foldmethod' is NOT" .
        \ " 'marker'!"
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
        let s:foldlevel = &foldlevel
        let &foldlevel = 20
    endif
    if a:when ==# 1
        let &foldlevel = s:foldlevel
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

function! s:CreatLevel() "{{{2

    call moveCursor#GotoFoldBegin()
    if foldlevel('.') ==# 0
        s/$/1/
    else
        execute 's/$/' . foldlevel('.') . '/'
    endif
    normal! ]z
    if foldlevel('.') ==# 0
        s/$/1/
    else
        execute 's/$/' . foldlevel('.') . '/'
    endif

endfunction "}}}2

function! s:ChangeLevel() "{{{2

    if line("'<") <# 1 ||
    \ line("'<") ># line('$') ||
    \ line("'>") <# 1 ||
    \ line("'>") ># line('$')
        echom 'ERROR: Visual block not found!'
        return
    endif

    let l:BeginNum =
    \ substitute(s:FoldBegin,'{0,2}','+','')
    let l:BeginNoNum =
    \ substitute(s:FoldBegin,'{0,2}','{0}','')
    let l:EndNum =
    \ substitute(s:FoldEnd,'{0,2}','+','')
    let l:EndNoNum =
    \ substitute(s:FoldEnd,'{0,2}','{0}','')

    normal! '<
    normal! 0
    if search(l:BeginNoNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:BeginNoNum .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    elseif search(l:BeginNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:BeginNum .
        \ '/s//\1 \2' . s:Bra . '/'
    endif

    normal! '<
    normal! 0
    if search(l:EndNoNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:EndNoNum .
        \ '/s/\v\s*$/\=foldlevel(".")/'
    elseif search(l:EndNum,'cnW',line("'>"))
        execute "'<,'>" . 'g/' . l:EndNum .
        \ '/s//\1' . s:Ket . '/'
    endif

endfunction "}}}2

function! s:Help() "{{{2

	echom '------------------------------'
	echom 'FoldMarker [args]'
	echom '------------------------------'
	echom 'Create new foldmarker...'
	echom '[blank] or i: after current l(I)ne'
	echom 'a: (A)fter current fold block'
	echom 'b: (B)efore current fold block'
	echom 's: (S)urround selected lines'
	echom '------------------------------'
	echom 'e: change fold l(E)vel'
	echom '------------------------------'

endfunction "}}}2

" main function
function! s:FoldMarker(where) "{{{2

	if <sid>DetectFoldMethod() ==# 1
        return
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
        if line("'<") ==# line("'>") ||
        \ getline(line("'<")) =~# s:FoldBegin ||
        \ getline(line("'>")) =~# s:FoldEnd
            call <sid>ExpandFold(1)
            return
        endif
        call <sid>CreatMarker(2)
    endif

    call <sid>CreatLevel()
    normal! [z
    call <sid>ExpandFold(1)
    normal! zz

endfunction "}}}2

function! s:FoldLevel() "{{{2

	if <sid>DetectFoldMethod() ==# 1
        return
    endif
    call <sid>LoadVars()
    call <sid>ExpandFold(0)
    call <sid>ChangeLevel()
    call <sid>ExpandFold(1)

endfunction "}}}2

function! s:SelectFuns(...) "{{{2

	if !exists('a:1') || a:1 ==# 'i'
        call <sid>FoldMarker('line')
	elseif a:1 ==# 'b'
        call <sid>FoldMarker('before')
	elseif a:1 ==# 'a'
        call <sid>FoldMarker('after')
	elseif a:1 ==# 's'
        call <sid>FoldMarker('surround')
	elseif a:1 ==# 'e'
        call <sid>FoldLevel()
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

" vim: set fdm=marker fdl=20 cc=50 "}}}1
