" default settings {{{
" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Mouse behavior (the Windows way)
behave mswin

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
" }}}

" 取消生成备份文件 {{{
set nobackup
set noswapfile
set noundofile
" }}}

" 基础设置 {{{
set number        " 显示行号
set numberwidth=3 " 更改行号的列宽 
set tabstop=4     " 设置 tab 宽度
set shiftwidth=4  " 设置自动缩进宽度
set softtabstop=4 " 设置按下 tab 键插入的空格数
set expandtab     " 用空格代替 tab 符号

syntax on "开启语法高亮

colorscheme default "设置颜色方案

set background=dark "设置背景模式

" }}}

" 状态栏 {{{
" 始终显示状态栏 
set laststatus=2    
 
set statusline=
set statusline+=%#PmenuSel#         " 左侧高亮色
set statusline+=%t\                 " 当前文件名
set statusline+=%m                  " [+] 如果文件被修改
set statusline+=\ -\ %y             " 文件类型
set statusline+=%=                  " 右侧起始
set statusline+=%#PmenuSel#         " 右侧高亮色
set statusline+=\ %l/%L             " 当前行号/总行号
set statusline+=\ \| 
set statusline+=\ Col\  
set statusline+=%c                  " 相对列号
set statusline+=\ \|  
set statusline+=\ %{&fileencoding}  " 编码格式
" }}}

" 映射 {{{
" leader ---- 前缀
let mapleader = "-"
let maplocalleader = "\\"
 
" 键盘映射
inoremap kj       <esc>
vnoremap kj       <esc>
noremap -         <nop>
inoremap <esc>    <nop>
noremap <left>    <nop>
inoremap <left>   <nop>
noremap <right>   <nop>
inoremap <right>  <nop>
noremap <up>      <nop>
inoremap <up>     <nop>
noremap <down>    <nop>
inoremap <down>   <nop>
            
" 快捷键映射
" 编辑 vimrc 文件
nnoremap <leader>ev :split $MYVIMRC<cr> 
" 重新加载 vimrc 文件
nnoremap <leader>sv :source $MYVIMRC<cr>
 
" 移动至上一行
nnoremap _ k
" 在编辑模式删除当前行
inoremap <C-d> <Esc> ddi  

" 当前单词修改为大写
inoremap <leader>U <Esc> viwUi
nnoremap <leader>U viwU

" 当前单词或选中句子添加引号
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
vnoremap <leader>" c"<c-r>""<esc>
vnoremap <leader>' c'<c-r>"'<esc>

" 移动映射
" 删除括号内内容
onoremap ( i(
onoremap { i{
onoremap [ i[
onoremap < i<

"重新编辑下一个括号内内容
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap in[ :<c-u>normal! f[vi[<cr>
onoremap in{ :<c-u>normal! f{vi{<cr>
onoremap in< :<c-u>normal! f<vi<<cr>
"重新编辑下一个括号内内容
onoremap il( :<c-u>normal! F)vi(<cr>
onoremap il[ :<c-u>normal! F]vi[<cr>
onoremap il{ :<c-u>normal! F}vi{<cr>
onoremap il< :<c-u>normal! F>vi<<cr>

" }}}

"修正与缩略 {{{
" 输入修正
iabbrev waht what

" 输入缩写
iabbrev @@    xciusdusk@gmail.com
iabbrev ccopy Copyright 2025 Xciusdusk, all rights reserved.
iabbrev langC #include <stdio.h><cr>int main()<cr>{<cr><cr><tab>return 0;<cr>}
iabbrev langCpp #include <iostream><cr>using namespace std;<cr>int main()<cr>{<cr><cr><tab>return 0;<cr>}
" }}}

" 自动化命令 {{{
augroup fileOperate
    autocmd!
    " 创建编辑文件
    autocmd BufNewFile * :w
    " 打开或保存文件时重新缩进
    autocmd BufWritePre,BufRead *.html,*.c,*.cpp,*.css,*.js,*.json,*.java,*.md,*.xml,*.conf,*.log,*.h :normal gg=G
    " 取消自动换行
    autocmd BufNewFile,BufRead *.html,*.css,*.js,*.json,*.md,*.xml,*.conf,*.log,*.h setlocal nowarp
augroup END

augroup commnet
    autocmd!
    " 单行添加注释
    " Python / Shell / Bash / Makefile 使用 #
    autocmd FileType python,sh,bash,zsh,make,conf
        \ nnoremap <buffer> <localleader>c I#<Esc> |

    " C / C++ / Java / JS / TS / Rust 使用 //
    autocmd FileType c,cpp,java,javascript,typescript,rust
        \ nnoremap <buffer> <localleader>c I//<Esc> |

    " HTML / XML 使用 <!-- --> 
    autocmd FileType html,xml
        \ nnoremap <buffer> <localleader>c I<!--<Esc>A--><Esc> |

    " JSON 
    autocmd FileType json
        \ nnoremap <buffer> <localleader>c I//<Esc> |
    
    " Vi
        \ nnoremap <buffer> <localleader>c I"<Esc>
augroup END
" }}}

" vimscript 文件设置 {{{
" 为 vimscript 文件设置折叠
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
