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

## 1. Download and install plugin

Download the plugin from [GitHub Repository](https://github.com/Bozar/foldMarker).

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

The plugin will show a breif help when the command is executed with a wrong argument, such as `:FoldMarker h`.

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

First enter Visual mode, then choose at least two lines.  Execute `:FoldMarker s`, which will creat a pair of fold markers in the first line and last line of Visual area.

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

If fold markers have wrong formats, refer to 2.10(Fold marker format), fold levels after such markers will not be deleted.

### 2.8 Argument `c`

First enter Visual mode, then choose text containing fold markers.  Execute `:FoldMarker c`, which will do two things:

*   Execute commands `:FoldMarker d`.
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

## 6. Version history

*   1.0.0--Creat English readme
*   0.10.0--Switch arguments `a` and `b`
*   0.9.3--Add new global variable `g:ComName_FoldMarker` to customize command name
*   0.9.2--`s:FoldMarker('surround')` will echo more error messages
*   0.9.1--Change names for script variables
*   0.9.0--The first stable version
