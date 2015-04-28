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

If Vim reports error: E117, E15 or E121, refer to 3.1( Autoload functions).

If plugin reports error:

    ERROR: 'foldmethod' is NOT 'marker'!

Refer to 3.2(`foldmethod`).

If `:FoldMarker` does not creat a pair of fold markers, refer to 3.3(`:FoldMarker` already exists).

## 6. Version history

*   1.0.0--Creat English readme
*   0.10.0--Switch arguments `a` and `b`
*   0.9.3--Add new global variable `g:ComName_FoldMarker` to customize command name
*   0.9.2--`s:FoldMarker('surround')` will echo more error messages
*   0.9.1--Change names for script variables
*   0.9.0--The first stable version
