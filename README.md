# foldMarker.vim

*   Version: 1.0.0
*   License: GPLv3

## Table of contents

1. Download and install plugin
2. New command `:FoldMarker`
3. Error messages
4. User-defined commands and key mappings
5. TODO list
6. Version history

foldMarker.vim defines a new command `:FoldMarker`, which can accpet six arguments to creat fold marker and adjust fold level.

Here is [the Simplified Chinese readme](https://github.com/Bozar/foldMarker/blob/master/README_CN.md).

## 1. Download and install plugin

Download the plugin from [GitHub Repository](https://github.com/Bozar/foldMarker) or [Vim home](http://www.vim.org/scripts/script.php?script_id=5166).

Copy the following two files to `~/.vim/`(`vimfiles/` for Windows users) :

    autoload/moveCursor.vim
    plugin/foldMarker.vim

Please be sure the plugin will not overwrite existing files.

Restart Vim.

## 2. New command `:FoldMarker`

### 2.1 Your first command

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

If Vim reports error: E117, E15 or E121, refer to 3.1(Autoload functions).

If plugin reports error:

    ERROR: 'foldmethod' is NOT 'marker'!

Refer to 3.2(`foldmethod`).

If `:FoldMarker` does not creat a pair of fold markers, refer to 3.3(`:FoldMarker` already exists).

### 2.2 Command arguments

`:FoldMarker` can accept six lower case alphabets as arguments: `l/a/b/s/c/d`.  It can also be executed with no argument, just as being executed with argument `l`.

*   `l`: creat a pair of fold markers under cursor `Line`
*   `a`: creat a pair of fold markers `Above` fold area
*   `b`: creat a pair of fold markers `Below` fold area
*   `s`: creat a pair of fold markers `Surrounding` Visual area
*   `c`: `Creat` fold level
*   `d`: `Delete` fold level

The plugin will show a brief help when the command is executed with a wrong argument, such as `:FoldMarker h`.

### 2.3 Argument `l`

`:FoldMarker l` will creat a pair of fold markers under cursor line.  See above, 2.1.

### 2.4 Argument `a`

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

### 2.5 Argument `b`

`:FoldMarker b` works like `:FoldMarker a`, that is, creat a pair of fold markers below cursor line or fold area.

### 2.6 Argument `s`

First enter Visual mode, then choose at least two lines.  Execute `:FoldMarker s`, which will creat a pair of fold markers in the first and last line of Visual area.

As long as markers `'<` and `'>` exist, and they are not in the same line, `:FoldMarker s` can also be executed in Normal mode.

Example(before):

    1   Title
    2
    3
    4

Execute commands:

    ggVG<esc>
    :FoldMarker s<cr>

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

    ERROR: Visual area not found!

Refer to 3.4(Mark `'<` and `'>`).

If plugin reports error:

    ERROR: Visual area only has one line!

Refer to 3.5(Number of lines in Visual area).

If plugin reports error:

    ERROR: Visual area already has fold marker!

Refer to 3.6(Visual area contains fold markers).

### 2.7 Argument `d`

Arguments `l/a/b/s/` will creat a pair of fold markers in the specific position.  Argument `c/d` will creat or delete fold level after fold markers.

First let's discuss `:FoldMarker d`.

First enter Visual mode, then choose text containing fold markers.  Execute `:FoldMarker d`, which will delete fold levels after fold markers.

Example(before):

    1   Title {1
    2   SubTitle {2
    3
    4   }2
    5   }1

Execute commands:

    ggV3j<esc>
    :FoldMarker d<cr>

Example(after):

    1   Title {
    2   SubTitle {
    3
    4   }
    5   }1

If fold markers have wrong formats, refer to 2.10(Fold marker pattern), fold levels after such markers will not be deleted.

### 2.8 Argument `c`

First enter Visual mode, then choose text containing fold markers.  Execute `:FoldMarker c`, which will do two things:

*   Execute command `:FoldMarker d`.
*   Creat fold levels after fold markers.

### 2.9 Change fold level

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

### 2.10 Fold marker pattern

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

## 3. Error messages

### 3.1 Autoload functions

If Vim reports error E117, E15 or E121, please confirm if `moveCursor.vim` exists in `~/.vim/autoload/` or `vimfiles/autoload/`.

### 3.2 `foldmethod`

If plugin reports error:

    ERROR: 'foldmethod' is NOT 'marker'!

Check current fold method by executing `:set foldmethod`.  Change fold method to `marker` by executing command:

    :set foldmethod=marker<cr>

### 3.3 `:FoldMarker` already exists

If `:FoldMarker` does not creat a pair of fold markers, perhaps other plugins have already defined this command.

Add a new line to `.vimrc` to define new command name:

    let g:ComName_FoldMarker = '{New Command Name}'

The new command name must begin with capital alphabet.

### 3.4 Mark `'<` and `'>`

If plugin reports error:

    ERROR: Visual area not found!

It means mark `'<` and `'>` does not exist or has already been deleted.  Refer to  Vim help, `:h E19`.

This error will appear in three circumstances.

marks do not exist:

    :new test<cr>
    :FoldMarker s<cr>

marks have been deleted:

    ggVG<esc>
    :delmarks < <cr>
    :FoldMarker s<cr>

lines containing marks have been deleted:

    ggVG<esc>
    Gdd
    :FoldMarker s<cr>

### 3.5 Number of lines in Visual area

If plugin reports error:

    ERROR: Visual area only has one line!

It means you have chosen only one line in Visual mode.  Choose at least two lines for `:FoldMarker s` to work properly.

### 3.6 Visual area contains fold markers

If plugin reports error:

    ERROR: Visual area already has fold marker!

It means there exists fold markers in the first or last line of Visual area.

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

## 4. User-defiend commands and key mappings

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

## 5. TODO list

### 5.1 Do not move cursor line

After executing commands `:FoldMarker l/a/b/s`, the cursor will stay in the first line of new fold area, then execute this command, `normal! zz`.

I wonder if it is necessary to move cursor line to the middle of screen.  I plan to add more options by providing a new global variable:

*   Do not move cursor line(unless the first line or last line of new fold area is outside screen)
*   `normal! zz`
*   `normal! zt`
*   `normal! zb`

### 5.2 Creat fold levels containing no fold markers

Add four new arguments, which work like:

    :FoldMarker l/a/b/s<cr>
    :FoldMarker d<cr>

Preserve four arguments: `L/A/B/S`.

### 5.3 Use fold levels inside Visual area

When creating new fold levels, count fold levels from fold markers inside Visual area.

Example(before):

    1   Title {3
    2   SubTitle {2
    3
    4   }2
    5   }1

Execute commands:

    :FoldMarker C<cr>

Example(after):

    1   Title {3
    2   SubTitle {4
    3
    4   }4
    5   }3

Preserve argument: `C`.

### 5.4 Delete fold markers inside Visual area

*   Delete fold markers in the first and last line inside Visual area
*   Delete all fold markers

Preserve argument: `D`.

## 6. Version history

*   1.0.0--Creat English readme
*   0.10.0--Switch arguments `a` and `b`
*   0.9.3--Add new global variable `g:ComName_FoldMarker` to customize command name
*   0.9.2--`s:FoldMarker('surround')` will echo more error messages
*   0.9.1--Change names for script variables
*   0.9.0--The first stable version
