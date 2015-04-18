# foldMarker.vim 插件使用说明

## version history

*   0.9.2   echom error msgs s:FoldMarker('surround')
*   0.9.1   change s:var names
*   0.9.0   first stable version

## 目录

*   下载插件
    +   仓库地址
    +   下载文件
    +   首先确保没有重名文件
    +   然后复制到 .vim/ 目录下
    +   重启 Vim
*   新增命令
    +   第一次输入命令
    +   正确效果
    +   报错
    +   正确与错误的参数
    +   l/a/b/s/d/c
    +   调整 fold_level
    +   fold_marker 的格式
*   错误提示
    +   E117，E15，E121
    +   FoldMarker 命令无效
    +   foldmethod
    +   visual block, not found
    +   visual block, one line
    +   visual block, fold marker
*   自定义命令和键映射
    +   在哪里添加设置
    +   设置内容
    +   如果设置了 g:var，这里也要相应地修改命令名
    +   新的命令和键映射避免与现有设置冲突
*   待办事项
    +   高优先级，zz
    +   中优先级：没有 fold_level
    +   折叠标记前后都有注释符号
    +   删除折叠标记（最外层标记，所有标记）

## 下载插件

### 仓库地址

https://github.com/Bozar/foldMarker

### 复制文件

*   autoload
*   plugin

## 确保没有重名文件

### Vundle

未经测试

## 新增命令

### 目录

*   参数
*   FoldMarker l
*   FoldMarker a
*   FoldMarker b
*   FoldMarker s
*   FoldMarker d
*   FoldMarker c
    +   特殊用法：调整 fold_level
*   fold_marker 的格式

### 参数

*   第一个命令，无参数
    +   输入命令
    +   输出效果
*   参数
    +   正确的参数
    +   错误的参数
    +   查看帮助
    +   FoldMarker h

### FoldMarker l

*   在光标所在行之后添加一对 fold_marker

*   示例（之前）
*   1
*   2 []
*   3
*   4
*   5

*   示例（说明和操作）
*   [] 代表光标的位置
*   :FoldMarker
*   :FoldMarker l
*   用 [[[ 和 ]]] 代替 Vim 默认的 fold_marker

*   示例（之后）
*   1
*   2 [F]OLDMARKER [[[1
*   3
*   4
*   5 ]]]1

### FoldMarker a

*   光标在 fold 区域之外
    +   作用相当于 FoldMarker l
*   光标在 fold 区域之内
    +   在当前 fold 区域之后添加一对 fold_marker

*   示例（之前，光标在第 1 行）
*   1 []
*   2 Title [[[1
*   3
*   4
*   5 ]]]1

*   示例（之后）
*   1
*   2 [F]OLDMARKER [[[1
*   3
*   4
*   5 ]]]1
*   6 Title [[[1
*   7
*   8
*   9 ]]]1

*   示例（之前，光标在第 3 行）
*   1
*   2 Title [[[1
*   3 []
*   4
*   5 ]]]1

*   示例（之后）
*   1
*   2 Title [[[1
*   3
*   4
*   5 ]]]1
*   6 [F]OLDMARKER [[[1
*   7
*   8
*   9 ]]]1

### FoldMarker b

*   类似 FoldMarker a
*   光标在 fold 区域之外
    +   在光标所在行之前添加一对 fold_marker
*   光标在 fold 区域之内
    +   在当前 fold 区域之前添加一对 fold_marker

### FoldMarker s

*   按 v 或 V 进入 visual_mode
*   选中至少两行
*   FoldMarker s
*   在选中区域的首行和尾行的结尾处添加 fold_marker
*   只要 `<` 和 `>` 这两个 mark 存在，并且不在同一行，即使处于 normal_mode 也能使用该命令

*   示例（之前）
*   1 []
*   2 Title
*   3
*   4
*   5

*   示例（之后，选中第 2-5 行）
*   1
*   2 [T]itle [[[1
*   3
*   4
*   5 ]]]1

*   示例（之后，选中第 3-5 行）
*   1
*   2 Title
*   3 [F]OLDMARKER [[[1
*   4
*   5 ]]]1

### FoldMarker d

*   按 v 或 V 进入 visual_mode
*   选中一块区域
*   :FoldMarker d
*   删除区域内所有 fold_marker 之后的 fold_level
*   如果出现以下情况，脚本
    +   不会报错
    +   也不会处理文本
*   选中的区域内没有 fold_marker
*   fold_marker 之后没有 fold_level
*   fold_marker 格式错误（见下文）

*   示例（之前）
*   1 Title [[[1
*   2 SubTitle [[[2
*   3
*   4 ]]]2
*   5 ]]]1

*   示例（之后，选中第 1-4 行）
*   1 Title [[[
*   2 SubTitle [[[
*   3
*   4 ]]]
*   5 ]]]1

### FoldMarker c

*   按 v 或 V 进入 visual_mode
*   选中一块区域
*   :FoldMarker c
*   先执行 :FoldMarker d
*   然后在区域内所有 fold_marker 之后添加 fold_level
*   始终不会报错
*   不会编辑文本
    +   没有 fold_marker
    +   仅包含格式错误的 fold_marker
*   会编辑文本
    +   包含 fold_marker，无论后面是否跟着 fold_level

*   参考前例
*   逆向操作，从“之后”到“之前”

*   特殊用法：增减 fold_level
*   以前有命令直接增减 fold_level
*   现在取消了
*   先复制/删除 fold_marker，再使用 FoldMarker c 命令增减 fold_level

*   示例（增加）
*   1 Title [[[1
*   2
*   3
*   4 ]]]1

*   ggyyp
*   ggVG
*   :FoldMarker c
*   ggdd

*   示例（结果）
*   1 Title [[[2
*   2
*   3
*   4 ]]]2

*   为什么取消直接修改 fold_level 的命令
*   不常用
*   需要写判断条件，让插件变得更复杂
    +   fold_level `>` 20
    +   fold_level `<`= 1
    +   没有 fold_level

### fold_marker 的格式

*   为了确保 :FoldMarker 命令工作正常，即
    +   a/b/l/s 可以在正确的位置生成新的 fold_marker
    +   c/d 可以新增/删除 fold_level
*   现有的 fold_marker 和 fold_level 需要符合以下格式
*   `<`blank`>` . [comment] . `<`fold_marker`>` . [fold_level] . [blank] . `<`$`>`
*   `<`必需`>`，[可选]
*   各个部分之间不能插入其它任何字符

*   使用 a/b/l/s 生成的新 fold_marker 符合以下格式
*   `<`blank`>` . [comment] . `<`fold_marker`>` . `<`fold_level`>` . `<`$`>`

*   blank
    +   空白字符，包括半角空格和制表符
*   fold_marker
    +   :echo &foldmarker 查看当前设定的 fold_marker
*   fold_level
    +   1-20
    +   如果超出范围
    +   c/d 正确工作
    +   a/b/l/s 可能无法在正确的位置生成新的 fold_marker
*   $
    +   行末（end of line）标记
    +   建议不要在 fold_marker 或 fold_level 之后插入空白字符

*   comment
    +   注释符号，比如："，#，%
    +   不能包含空白字符
    +   非空白字符的数量不限
*   c/d：不会改动 comment
*   a/b/l/s：在新生成的 fold_marker 前添加 comment

*   示例
*   1 fun! s:Test() "[[[1
*   2   if 1
*   3       echo 'hello'
*   4   endif
*   5 endfun "]]]1

*   选中第 2-4 行
*   :FoldMarker s

*   示例（结果）
*   1 fun! s:Test() "[[[1
*   2   if 1 "[[[2
*   3       echo 'hello'
*   4   endif "]]]2
*   5 endfun "]]]1

*   如果 fold_marker 之后出现除了数字以外的非空白字符
*   不会报错，但是命令无法正常工作
*   错误格式如下
*   `<`blank 1`>` . [comment 1] . `<`fold_marker`>` . [comment 2] . [fold_level] . [comment 3] . [blank 2] . [comment 4] . `<`$`>`

*   a/b/l/s 生成的新 fold_marker
*   删除 comment 1-4，blank 2
*   `<`blank`>` . `<`fold_marker`>` . `<`fold_level`>` . `<`$`>`

*   c/d
*   格式错误的 fold_marker 之后不会增加或删除 fold_level

## 错误提示

### E117，E15，E121

*   .vim/autoload/moveCursor.vim

*   是否存在？
*   是否被修改？

### FoldMarker 命令无效

*   现象：FoldMarker 命令没有生成一对折叠标记
*   原因：其它插件可能已经定义了这个命令
*   解决办法：
    +   向 .vimrc 内添加一行
    +   let g:ComName_FoldMarker = '{New Command Name}'
    +   命令名字必须以大写字母开头

### foldmethod

*   set foldmethod=marker

### visual block, not found

*   按 V 进入 visual mode，选中区域
*   Vim 在该区域的首行和尾行添加 mark：`<` 和 `>`
*   缺少任何一个 mark 都会报错
*   适用于以下参数：
    +   FoldMarker s
    +   FoldMarker c
    +   FoldMarker d
*   测试 1：新建一个文本文件（此时 `<` 和 `>` 这两个 mark 尚不存在）
*   测试 2：用 :delmark 删除 mark
*   测试 3：
    +   文本共 10 行
    +   先选中第 7-10 行，再返回 normal mode
    +   删除第 10 行

### visual block, one line

进入 visual mode 后只选中一行

### visual block, fold marker

*   进入 visual mode 选中一块区域
*   该区域的首行和/或尾行含有 fold marker
    +   1
    +   2 开头 [[[5
    +   3
    +   4
    +   5 结尾 ]]]5
    +   6
*   报错：
    +   选中第 2-5 行
    +   选中第 1-2 行
    +   选中第 5-6 行
*   不报错：
    +   选中第 1-3 行
    +   选中第 3-4 行
    +   选中第 3-6 行

## 自定义命令和键映射

我向 .vimrc 添加了以下命令和键映射：

*   " foldMarker.vim

*   command! -range FmAfter FoldMarker a
*   command! -range FmBefore FoldMarker b
*   command! -range FmLine FoldMarker l
*   command! -range FmSurround FoldMarker s
*   command! -range FmCreLevel FoldMarker c
*   command! -range FmDelLevel FoldMarker d

*   nnoremap `<`silent`>` `<`tab`>` :FoldMarker a`<`cr`>`
*   nnoremap `<`silent`>` `<`s-tab`>` :FoldMarker b`<`cr`>`
*   nnoremap `<`silent`>` `<`c-tab`>` :FoldMarker l`<`cr`>`
*   vnoremap `<`silent`>` `<`c-tab`>` :FoldMarker s`<`cr`>`

*   nnoremap `<`silent`>` `<`a-=`>` :FoldMarker c`<`cr`>`
*   nnoremap `<`silent`>` `<`a--`>` :FoldMarker d`<`cr`>`
*   vnoremap `<`silent`>` `<`a-=`>` :FoldMarker c`<`cr`>`
*   vnoremap `<`silent`>` `<`a--`>` :FoldMarker d`<`cr`>`

## 待办事项

### zz

*   使用以下命令：
    +   FoldMarker l
    +   FoldMarker b
    +   FoldMarker a
    +   FoldMarker s
*   光标停留在新的 fold 区域首行
*   normal! zz
*   考虑：是否有必要把光标所在行移动到屏幕中间？
*   是否可以选择：
    +   不移动（除非 fold 的首行或尾行超出屏幕边缘）
    +   zz
    +   zt
    +   zb
*   高优先级
*   可能等到 1.0.0 版以后增加

### 生成没有 fold_level 的 fold_marker

*   作用相当于 FoldMarker ld
*   预留四个参数：A/B/L/S

### 折叠标记前后都有注释符号

*   fold marker 之后含有除了数字以外的非空白字符
*   FoldMarker c/d
    +   fold level 不会更新
*   FoldMarker a/b/l/s
    +   删除 fold marker 前、后除了数字以外的非空白字符
*   考虑：是否让插件识别被注释“包围”的 fold marker？
*   低优先级
*   目前我只在写 HTML 时遇到这个问题
*   根据缩进来折叠复杂的文档
    +   set foldmethod=indent
*   改写正则表达式有点麻烦

### 删除折叠标记（最外层标记，所有标记）

*   进入 visual mode 选中区域
*   新增两个参数：
    +   删除首行/尾行的折叠标记
    +   删除区域内所有折叠标记
*   低优先级
*   如果需要把带有 fold marker 的文本转换成其它格式：
    +   markdown
    +   BBCode
    +   HTML
*   建议直接写脚本，批量替换 fold marker

