foldMarker.vim 使用说明

*   版本：1.1.0
*   协议：GPLv3

## 目录

1. 简介
2. 下载并安装插件
3. 新命令 `:FoldMarker`
4. 错误提示
5. 自定义命令和键映射
6. 版本历史

## 1. 简介

foldMarker.vim 定义了一个新命令 `:FoldMarker` 。这个命令可以接受十四个参数，用来在指定位置生成/删除 fold marker 和 fold level。

## 2. 下载并安装插件

进入 [GitHub 仓库](https://github.com/Bozar/foldMarker)或 [Vim 官网](http://www.vim.org/scripts/script.php?script_id=5166) 下载插件。

把下面这两个文件复制到 `~/.vim/` 目录下（Windows 用户把文件复制到 `vimfiles/` 目录下）：

    autoload/moveCursor.vim
    plugin/foldMarker.vim

请确保该插件不会覆盖现有的同名文件。

重启 Vim。

## 3. 新命令 `:FoldMarker`

### 3.1 第一次输入命令

输入命令 `:FoldMarker`，在 cursor line 之下应该出现一对 fold markers。

示例（之前）：

    1   []
    2
    3
    4

示例（之后）：

    1
    2   [F]OLDMARKER {1
    3
    4
    5   }1

`[]` 代表光标的位置。我用 `{` 和 `}` 代替 Vim 默认的 fold marker。

如果出现错误 E117、E15 或 E121，请查阅 4.1（Autoload 函数）。

如果出现错误——

    ERROR: 'foldmethod' is NOT 'marker'!

请查阅 4.2（`foldmethod`）。

如果 `:FoldMarker` 没有生成一对 fold markers，请查阅 4.3（`:FoldMarker` 命令已存在）。

### 3.2 命令参数

`:FoldMarker` 可以接受十四个字母作为参数，也可以不接受参数直接执行，此时效果和 `l` 参数相同。这些参数分为四类：

在指定位置生成一对 fold markers：

*   `l/L`：在 cursor line 之下（`Line`）生成一对 fold markers。
*   `a/A`：在 fold area 之上（`Above`）生成一对 fold markers。
*   `b/B`：在 fold area 之下（`Below`）生成一对 fold markers。
*   `s/S`：在指定范围内（`Surround`）生成一对 fold markers。

添加或删除 fold level：

*   `c/C`：添加（`Creat`）fold level。
*   `d`：删除（`Delete`）fold level。

删除 fold marker：

*   `r/R`：在指定范围内删除最外层/所有的 fold markers。

查阅帮助：

*   `h`：显示简短的参数说明。

### 3.3 参数 `l/L`

`:FoldMarker l/L` 在 cursor line 之下生成一对 fold markers。示例见上文，3.1。

小写参数生成的 fold markers 之后跟着 fold levels，大写参数生成的 fold markers 之后没有 fold levels。这条规则适用于以下四对参数：

*   l/L
*   a/A
*   b/B
*   s/S

### 3.4 参数 `a/A`

如果光标在 fold area 之外，那么 `:FoldMarker a` 在 cursor line 之上生成一对 fold markers。

如果光标在 fold area 之内，那么 `:FoldMarker a` 在 fold area 之上生成一对 fold markers。

示例（之前）：

    1   Title {1
    2   []
    3
    4   }1

示例（之后）：

    1   [F]OLDMARKER {1
    2
    3
    4   }1
    5   Title {1
    6
    7
    8   }1

### 3.5 参数 `b/B`

`:FoldMarker b` 的作用和 `:FoldMarker a` 类似，即在 cursor line 之下，或者在 fold area 之下生成一对 fold markers。

### 3.6 参数 `s/S`

进入 Visual mode，选中至少两行，`:FoldMarker s` 将在 Visual area 的首行和尾行添加一对 fold markers。

示例（之前）：

    1   Title
    2
    3
    4

执行命令：

    ggVG<esc>
    :FoldMarker s<cr>

或者在 Normal mode 下指定命令的执行范围：

    :1,4FoldMarker s

示例（之后）：

    1   [T]itle {1
    2
    3
    4   }1

如果执行命令：

    :2,4FoldMarker s

效果略有不同：

    1   Title
    2   [F]OLDMARKER {1
    3
    4   }1

如果出现错误——

    ERROR: Command range only has one line!

请查阅 4.4（命令范围）。

如果出现错误——

    ERROR: Line X has fold marker!

请查阅 4.5（指定区域包含 fold markers）。

### 3.7 参数 `d`

上述四组参数能在指定位置生成一对 fold markers，参数 `c/C/d` 的作用是在 fold marker 之后添加或删除 fold level。先来讨论命令 `:FoldMarker d`。

示例（之前）：

    1   Title {1
    2   SubTitle {2
    3
    4   }2
    5   }1

输入命令：

    :%FoldMarker d<cr>

示例（之后）：

    1   Title {
    2   SubTitle {
    3
    4   }
    5   }

如果 fold marker 格式错误，见下文 3.12（fold marker 的格式），那么 fold marker 之后的 fold level 不会被删除。

### 3.8 参数 `c/C`

进入 Visual mode，选中含有 fold marker 的文本，`:FoldMarker c` 将执行两步操作：

*   执行命令 `:FoldMarker d`。
*   在 fold marker 之后添加 fold level。

调整 fold level

`:FoldMarker c` 还能调整 fold level。

示例（之前）：

    1   Title {1
    2
    3
    4   }1

如果要把 1 级 fold 变成 2 级，可以执行以下命令：

    ggyyp
    ggVG<esc>
    :FoldMarker c<cr>
    ggdd

示例（之后）：

    1   Title {2
    2
    3
    4   }2

如果要把 2 级 fold 变回 1 级，可以这么做：

    ggVG<esc>
    :FoldMarker c<cr>

### 3.9 参数 `r/R`

### 3.10 参数 `h`

### 3.11 命令的范围

### 3.12 fold marker 的格式

为了确保 `:FoldMarker` 正常工作，即：

*   `l/a/b/s` 可以在正确的位置生成新的 fold marker
*   `c/d` 可以增加/删除 fold level

用户输入的 fold marker 和 fold level 需要符合以下格式：

*   `<`blank`>` . `[comment]` . `<`fold marker`>` . `[fold level]` . `[blank]` . `<`$`>`

符号说明：

*   `<>`：必需的内容
*   `[]`：可选的内容
*   `.`：两个部分之间不能插入其它字符

`l/a/b/s` 生成的新 fold marker 符合以下格式：

*   `<`blank`>` . `[comment]` . `<`fold marker`>` . `<`fold level`>` . `<`$`>`

接下来逐一说明各部分的含义。

`<`blank`>`。空白字符 `\s`，包括半角空格和制表符。

`<`fold marker`>`。用命令 `:set foldmarker` 来查看当前设定的 fold marker。

`<`fold level`>`。1-20 之间的数字。

`<`$`>`。行末标记。建议不要在 fold level 之后插入空白字符。

`[comment]`。注释符号，比如 `"`、`#` 或 `%`。 `[comment]` 内不能包含空白字符，但是可以包含多个非空白字符。

`c/d` 不会改动 `[comment]`， `l/a/b/s` 会在新生成的 fold marker 前添加 `[comment]`。

示例（之前）：

    1   Title "{1
    2   []
    3
    4   "}1

执行命令：

    :FoldMarker b<cr>

示例（之后）：

    1   Title "{1
    2
    3
    4   "}1
    5   [F]OLDMARKER "{1
    6
    7
    8   "}1

如果 fold marker 之后出现除了数字以外的非空白字符，比如：

*   `<`blank 1`>` . `[comment 1]` . `<`fold marker`>` . `[comment 2]` . `[fold level]` . `[comment 3]` . `[blank 2]` . `[comment 4]` . `<`$`>`

`l/a/b/s` 生成的新 fold marker 将删除 `[comment 1-4]` 和 `[blank 2]`。

*   `<`blank`>` . `<`fold marker`>` . `<`fold level`>` . `<`$`>`

`c/d` 不会添加或删除格式错误的 fold marker 之后的 fold level。

## 4. 错误提示

### 4.1 Autoload 函数

如果出现错误 E117、E15 或 E121，请确认 `~/.vim/autoload/` 或者 `vimfiles/autoload/` 目录下是否存在 `moveCursor.vim` 这个文件。

### 4.2 `foldmethod`

如果出现错误——

    ERROR: 'foldmethod' is NOT 'marker'!

请用命令 `:set foldmethod` 来查看当前设定的 fold marker。如果当前的 fold method 不是 `marker`，请调整设置：

    :set foldmethod=marker<cr>

### 4.3 `:FoldMarker` 命令已存在

如果 `:FoldMarker` 没有生成一对 fold markers，可能是因为其它插件已经定义了这个命令。

请向 `.vimrc` 内添加一行，设置新的命令名：

    let g:ComName_FoldMarker = '{New Command Name}'

命令名必须以大写字母开头。

### 4.4 命令范围

如果出现错误——

    ERROR: Command range only has one line!

请在 Visual mode 内选中至少两行，或者在 Normal mode 内指定至少两行作为执行命令的范围，比如 `:1,2FoldMarker s` ，这样 `:FoldMarker s` 才能正常工作。

### 4.5 指定区域包含 fold marker

如果出现错误——

    ERROR: Line X has fold marker!

这表明指定区域的首行和/或尾行（第 X 行）含有 fold marker。

对于以下文本：

    1
    2   Head {5
    3
    4
    5   Tail }5
    6

会报错的情况包括：

*   选中第 2-5 行
*   选中第 1-2 行
*   选中第 5-6 行

不报错的情况包括：

*   选中第 1-3 行
*   选中第 3-4 行
*   选中第 3-6 行

## 5. 自定义命令和键映射

我向 .vimrc 添加了以下命令和键映射：

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

## 6. 版本历史

*   1.1.0
    +   修复：修改脚本变量 s:FoldEnd 的格式，让插件正确识别 fold marker，比如 `[[[` 。
    +   新增：新增 8 个命令参数，L/A/B/S/C/r/R/h。
    +   新增：新增全局变量 g:MoveFold_FoldMarker，用来移动新生成的 fold marker。
    +   新增：除了 `'<` 和 `'>`，命令 `:FoldMarker` 可以接受更多范围，比如 `:1,5FoldMarker`。
*   1.0.0
    +   新增英文说明文档。
*   0.10.0
    +   交换参数 `a` 和 `b` 的功能。
*   0.9.3
    +   新增全局变量 `g:ComName_FoldMarker`，用来自定义命令名。
*   0.9.2
    +   `s:FoldMarker('surround')` 会显示更多错误提示。
*   0.9.1
    +   更改脚本变量名。
*   0.9.0
    +   第一个稳定版本。
