# foldMarker.vim

*   Version: 1.1.0
*   License: GPLv3

## Table of contents

1. Introduction
2. Download and install plugin
3. New command `:FoldMarker`
4. Error messages
5. User-defined commands and key mappings
6. Version history

## 1. Introduction

foldMarker.vim defines a new command `:FoldMarker`, which can accpet fourteen arguments to creat/delete fold marker and fold level.

Here is [the Simplified Chinese readme](https://github.com/Bozar/foldMarker/blob/master/README_CN.md).

## 2. Download and install plugin

Download the plugin from [GitHub Repository](https://github.com/Bozar/foldMarker) or [Vim home](http://www.vim.org/scripts/script.php?script_id=5166).

Copy the following two files to `~/.vim/`( `vimfiles/` for Windows users) :

    autoload/moveCursor.vim
    plugin/foldMarker.vim

Please be sure the plugin will not overwrite existing files.

Restart Vim.

## 3. New command `:FoldMarker`

### 3.1 Your first command

Execute command `:FoldMarker`.  The plugin should creat a pair of fold markers under cursor line .

Example(before):

    1   []
    2
    3
    4

Example(after):

    1
    2   [F]OLDMARKER {1
    3
    4
    5   }1

`[]` represents cursor position.  `{` and `}` represent Vim's default fold markers.

If Vim reports error: E117, E15 or E121, refer to 4.1(Autoload functions).

If plugin reports error:

    ERROR: 'foldmethod' is NOT 'marker'!

Refer to 4.2(`foldmethod`).

If `:FoldMarker` does not creat a pair of fold markers, refer to 4.3(`:FoldMarker` already exists).

### 3.2 Command arguments

`:FoldMarker` can accept fourteen alphabets as arguments.  It can also be executed with no argument, just as being executed with argument `l`.  These arguments are classified into four groups:

Creat a pair of fold markers in the specified position:

*   `l/L`: creat a pair of fold markers under cursor `(L)ine`
*   `a/A`: creat a pair of fold markers `(A)bove` fold area
*   `b/B`: creat a pair of fold markers `(B)elow` fold area
*   `s/S`: creat a pair of fold markers `(S)urrounding` the specified area

Creat or delete fold levels:

*   `c/C`: `(C)reat` fold levels
*   `d`: `(D)elete` fold levels

Delete fold markers:

*   `r/R`: `(R)emove` the outermost/all fold markers in the specified area

Read help:

*   `h`: read `(H)elp` for command arguments

### 3.3 Argument `l/L`

`:FoldMarker l/L` will creat a pair of fold markers under cursor line.  See above, 3.1.

Lower case arguments creat both fold markers and fold levels.  Upper case arguments creat fold markers without fold levels.  This rule applies to four pairs of arguments:

*   l/L
*   a/A
*   b/B
*   s/S

### 3.4 Argument `a/A`

If cursor is outside fold area, then `:FoldMarker a` will creat a pair of fold markers above cursor line.

If cursor is inside fold area, then `:FoldMarker a` will creat a pair of fold markers above fold area.

Example(before):

    1   Title {1
    2   []
    3
    4   }1

Example(after):

    1   [F]OLDMARKER {1
    2
    3
    4   }1
    5   Title {1
    6
    7
    8   }1

### 3.5 Argument `b/B`

`:FoldMarker b` works like `:FoldMarker a`, that is, creat a pair of fold markers below cursor line or fold area.

### 3.6 Argument `s/S`

First enter Visual mode, then choose at least two lines.  Execute `:FoldMarker s`, which will creat a pair of fold markers in the first and last line of Visual area.

Example(before):

    1   Title
    2
    3
    4

Execute commands:

    ggVG<esc>
    :FoldMarker s<cr>

You can also execute this command in Normal mode:

    :1,4FoldMarker s

Example(after):

    1   [T]itle {1
    2
    3
    4   }1

Execute commands:

    ggjVG<esc>
    :FoldMarker s<cr>

A new fold title will be created:

    1   Title
    2   [F]OLDMARKER {1
    3
    4   }1

If plugin reports error:

    ERROR: Command range only has one line!

Refer to 4.4(Command range).

If plugin reports error:

    ERROR: Line X has fold marker!

Refer to 4.5(Fold markers exist in specified area).

### 3.7 Argument `d`

Those four pairs of arguments described above creat a pair of fold markers in the specific position.  Arguments `c/C/d` creat or delete fold level after fold markers.  First let's discuss `:FoldMarker d`.

Example(before):

    1   Title {1
    2   SubTitle {2
    3
    4   }2
    5   }1

Execute commands:

    :%FoldMarker d<cr>

Example(after):

    1   Title {
    2   SubTitle {
    3
    4   }
    5   }

If fold markers have wrong formats, refer to 3.12(Fold marker pattern), fold levels after such markers will not be deleted.

### 3.8 Argument `c/C`

First enter Visual mode, then choose text containing fold markers.  Execute `:FoldMarker c`, which will do two things:

*   Execute command `:FoldMarker d`.
*   Creat fold levels after fold markers.

Change fold level

`:FoldMarker c` can be used to change fold level.

Example(before):

    1   Title {1
    2
    3
    4   }1

Execute these commands to change a level one fold into level two:

    ggyyp
    ggVG<esc>
    :FoldMarker c<cr>
    ggdd

Example(after):

    1   Title {2
    2
    3
    4   }2

Execute these commands to change a level two fold back to level one:

    ggVG<esc>
    :FoldMarker c<cr>

### 3.9 Argument `r/R`

### 3.10 Argument `h`

### 3.11 Command range

### 3.12 Fold marker pattern

In order to make sure `:FoldMarker` to work properly, that is to say:

*   `l/a/b/s` will creat a pair of fold markers in the right position
*   `c/d` will creat/delete fold levels

Fold markers and fold levels inserted by users should match the following pattern:

*   `<`blank`>` . `[comment]` . `<`fold marker`>` . `[fold level]` . `[blank]` . `<`$`>`

Brief summary for markers:

*   `<>`: must-have content
*   `[]`: optional content
*   `.`: join two parts without inserting any other characters

New fold markers created by `l/a/b/s` match the following pattern:

*   `<`blank`>` . `[comment]` . `<`fold marker`>` . `<`fold level`>` . `<`$`>`

Let's discuss every part in detail.

`<`blank`>`: Blank character `\s`, including half-width space and tab.

`<`fold marker`>`: Check current fold markers by executing `:set foldmarker`.

`<`fold level`>`: Numbers between 1 to 20.

`<`$`>`: End of line.  It is recommened not to add any more blank characters after fold level.

`[comment]`: Comments such as `"`, `#` and `%`.  There should not be blank characters inside `[comment]`, but more than one non-blank characters are allowed.

`c/d` will not modify `[comment]`.  `l/a/b/s` will creat new `[comment]` before fold markers.

Example(before):

    1   Title "{1
    2   []
    3
    4   "}1

Execute commands:

    :FoldMarker b<cr>

Example(after):

    1   Title "{1
    2
    3
    4   "}1
    5   [F]OLDMARKER "{1
    6
    7
    8   "}1

If there exist non-blank characters other than numbers after fold markers, such as:

*   `<`blank 1`>` . `[comment 1]` . `<`fold marker`>` . `[comment 2]` . `[fold level]` . `[comment 3]` . `[blank 2]` . `[comment 4]` . `<`$`>`

`l/a/b/s` will creat new fold markers without `[comment 1-4]` and `[blank 2]`.

*   `<`blank`>` . `<`fold marker`>` . `<`fold level`>` . `<`$`>`

`c/d` will not creat or delete fold levels after fold markers which have wrong pattern.

## 4. Error messages

### 4.1 Autoload functions

If Vim reports error E117, E15 or E121, please confirm if `moveCursor.vim` exists in `~/.vim/autoload/` or `vimfiles/autoload/`.

### 4.2 `foldmethod`

If plugin reports error:

    ERROR: 'foldmethod' is NOT 'marker'!

Check current fold method by executing `:set foldmethod`.  Change fold method to `marker` by executing command:

    :set foldmethod=marker<cr>

### 4.3 `:FoldMarker` already exists

If `:FoldMarker` does not creat a pair of fold markers, perhaps other plugins have already defined this command.

Add a new line to `.vimrc` to define new command name:

    let g:ComName_FoldMarker = '{New Command Name}'

The new command name must begin with capital alphabet.

### 4.4 Command range

If plugin reports error:

    ERROR: Command range only has one line!

Choose at least two lines in Visual mode or Normal mode, such as `:1,2FoldMarker s`, so that `:FoldMarker s` can work properly.

### 4.5 Fold markers exist in specified area

If plugin reports error:

    ERROR: Line X has fold marker!

It means there exists fold markers in the first or last line of specified area.

For example:

    1
    2   Head {5
    3
    4
    5   Tail }5
    6

The plugin will report error when you choose:

*   Line 2-5
*   Line 1-2
*   Line 5-6

The plugin will NOT report error when you choose:

*   Line 1-3
*   Line 3-4
*   Line 3-6

## 5. User-defiend commands and key mappings

You can define your own commands and key mappings by adding such lines into .vimrc:

    command! -range FmAbove FoldMarker a
    command! -range FmBelow FoldMarker b
    command! -range FmLine FoldMarker l
    command! -range FmSurround FoldMarker s
    command! -range FmCreLevel FoldMarker c
    command! -range FmDelLevel FoldMarker d

    nnoremap <silent> <tab> :FoldMarker b<cr>
    nnoremap <silent> <s-tab> :FoldMarker a<cr>
    nnoremap <silent> <c-tab> :FoldMarker l<cr>
    vnoremap <silent> <c-tab> :FoldMarker s<cr>

    nnoremap <silent> <a-=> :FoldMarker c<cr>
    nnoremap <silent> <a--> :FoldMarker d<cr>
    vnoremap <silent> <a-=> :FoldMarker c<cr>
    vnoremap <silent> <a--> :FoldMarker d<cr>

## 6. Version history

*   1.1.0
    +   Fix: Change search pattern for script variable `s:FoldEnd`, so that the plugin can recognize fold markers such as `[[[`
    +   Add: Add 8 new arguments, L/A/B/S/C/r/R/h
    +   Add: Add a global variable `g:MoveFold_FoldMarker` to move new fold marker
    +   Add: Let `:FoldMarker` accpet more ranges besides `'<` and `'>`, such as `:1,5FoldMarker`
*   1.0.0
    +   Creat English readme
*   0.10.0
    +   Switch arguments `a` and `b`
*   0.9.3
    +   Add new global variable `g:ComName_FoldMarker` to customize command name
*   0.9.2
    +   `s:FoldMarker('surround')` will echo more error messages
*   0.9.1
    +   Change names for script variables
*   0.9.0
    +   The first stable version
