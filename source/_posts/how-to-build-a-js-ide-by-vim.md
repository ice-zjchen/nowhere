---
title: How to build a Javascript IDE by Vim
date: 2017.01.25 22:31
tags:
---
# 写在前面
旧链接：[我可能搞了一个假IDE——使用vim+tmux打造IDE for JavaScript 全栈开发](http://www.jianshu.com/p/b4edd73c696b)
## 为什么要用vim
如果一定要讲一个清新脱俗的理由，那是因为**用vim对颈椎和腰椎好**（严肃脸）。使用vim时候，是不需要一只手控制鼠标或者触控板的。当两只手都放在键盘上，就能将脖子和双肩放松，身体放正，挺直腰背，目光平视屏幕了，咳咳。
## 为什么重复造轮子
Github上关于[vim的配置](https://github.com/VundleVim/Vundle.vim/wiki/Examples)已经有很多了，但没有真正一统vim界的最佳实践（如zsh的oh-my-zsh，emacs的space-emacs，不过由于space-emacs催生出一个space-vim），所以要打造简约专属的IDE，还得自己造轮子。稍微谷歌或百度一下，就会有各种vim配置的教程，思路也基本一致，所幸不是特别麻烦。

## 对IDE的需求
![IDE的最终效果图](http://upload-images.jianshu.io/upload_images/220182-ddae90d8d23c9141.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 显示区块： 项目结构，文件编辑，文件结构，Shell操作，Log显示
- 主要语言：Javascript，HTML，CSS等
- 次要语言：Python，Shell等
- 使用习惯：拥有sublime text的众多特性

在sublime中编辑+terminal中查看log、执行git操作，两者来回切换相当麻烦；而webstorm虽然强大，但消耗太大。用tmux的多屏复用+vim的强大插件足以打造一个能满足以上要求IDE了。

## 适合本文的读者
打算用vim打造IDE的新手。没有耐心的同学可以拉到最后看总结，直接去各个reference看原始文档。希望本文能对你在配置vim过程中有一丢丢帮助。

# 开始搭建
## 准备工作
环境：MacOS 或 Linux
- 安装iTerm2和zsh（推荐）
前往iTerm2[官网](https://www.iterm2.com/)下载，以及使用[oh-my-zsh](http://ohmyz.sh/)一键安装配置。具体可参考：Sourabh Bajaj 的 [Mac OS X Setup Guide](http://sourabhbajaj.com/mac-setup)
- 安装tmux（必须）
```bash
$ brew install tmux
```
- 安装vim（必须）
```bash
$ brew install vim --with-lua --with-override-system-vi
```

##  Vim配置
vim编辑器所有的配置都在 ```~/.vimrc``` 下，我们配置下第一个插件**[Vundle.vim](https://github.com/VundleVim/Vundle.vim)**——管理插件的插件。

### 插件管理
Vundle可以让你在配置文件中管理插件，并且非常方便的查找、安装、更新或者删除插件。 还可以帮你自动配置插件的执行路径和生成帮助文件，相对于Pathongen有巨大优势。你也可以用NeoBundle或者VimPlug，此处不作展开。
```bash
# vundle 安装
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```
将下面配置加入到`.vimrc`文件中
```
" unleash all Vim power"
set nocompatible 
filetype off     

"  set the runtime path to include Vundle and initialize"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required"
Plugin 'gmarik/Vundle.vim'

" Vundle List Here"


call vundle#end() 
filetype plugin indent on
```
接着执行安装命令即可安装完毕
```
# 在vim中
:PluginInstall

# 在终端
vim +PluginInstall +qall
```
为了方便vim配置的管理，创建新文件`~/.vimrc_vundle`将以上关于插件部分的配置写入其中，然后再从`~/.vimrc`中引入。
```
" ~/.vimrc文件"
set nocompatible 
filetype off

let $CONFIG_DIR = "~/"

" vundle config"
let $VUNDLE_CONFIG = $CONFIG_DIR.".vimrc_vundle"
if filereadable(expand($VUNDLE_CONFIG))
  source $VUNDLE_CONFIG
endif
```
```
"~/.vimrc_vundle文件"

"  set the runtime path to include Vundle and initialize"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required"
Plugin 'gmarik/Vundle.vim'

" Vundle List Here"


call vundle#end() 
filetype plugin indent on
```

### 添加vim插件与配置
我们在`~/.vimrc`中添加插件配置，在`~/.vimrc_vundle`中添加插件 。vim的插件可以在[VimAwesome](http://vimawesome.com/)这个非常awesome的网站上寻找，它有用Vundle安装的脚本，直接复制粘贴就行了。

![vimawesome的安装指导](http://upload-images.jianshu.io/upload_images/220182-a2bd33a3c3915eb4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


**a. 配色主题**
所谓颜即是正义，赏心悦目的配色主题很重要。我用的配色是 [molokai](https://github.com/tomasr/molokai) 主题
```
"~/.vimrc_vundle文件"

" Vundle List Here"
Plugin 'tomasr/molokai'
```
```
" ~/.vimrc文件"

" vim theme"
colorscheme molokai
```

**b. 项目结构**
左窗口用 NerdTree插件 `Plugin 'scrooloose/nerdtree'`，是一个用于浏览目录结构的插件，配置如下：
```
" NERDTree"
let NERDChristmasTree=0
let NERDTreeWinSize=35
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos="left"
let g:nerdtree_tabs_open_on_gui_startup=1
let g:nerdtree_tabs_open_on_console_startup=1

autocmd vimenter * if !argc() | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nmap <F5> :NERDTreeToggle<cr>
```
**c. 文件结构**
右窗口用 tagbar插件 `Plugin 'majutsushi/tagbar`，为我们提供了一个简单的方式去浏览当前文件的结构，并且支持在各个标签之间快捷的跳转。配置如下：
```
" Tagbar"
let g:tagbar_width=35
let g:tagbar_autofocus=1
nmap <F6> :TagbarToggle<CR>

" parse markdown"
let g:tagbar_type_markdown = {
  \ 'ctagstype' : 'markdown',
  \ 'kinds' : [
    \ 'h:Heading_L1',
    \ 'i:Heading_L2',
    \ 'k:Heading_L3'
  \ ]
\ }

```

使用tagbar还需要安装 [Exuberant ctags](http://ctags.sourceforge.net/)
``` bash
$ brew install ctags
```
由此，左右两侧的导航插件安装完成。按F5和F6唤出左右窗口，窗口之间的切换使用ctrl+w。

**d. 对js文件结构分析的优化**
tagbar本身对javascript的分析不够，所以还需要额外的插件去支持对javascr以及ES6做标签化处理，[推荐解决方案](https://github.com/majutsushi/tagbar/wiki#jsctags-depends-on-tern--recommended-) 是使用jsctags，当然也可以采用其他tagbar在wiki中的[其他方案](https://github.com/majutsushi/tagbar/wiki#javascript)。关于jsctags的解决方式如下：
- 用 vundle 安装 tern_for_vim 插件
- 在 `~/.vim/bundle/tern_for_vim` 下执行 `npm install`
- 安装 jsctags
```
npm install -g git+https://github.com/ramitos/jsctags.git
```
- `~/.vimrc` 添加对js处理的配置
```
let g:tagbar_type_javascript = {
  \ 'ctagsbin' : 'jsctags'
\ }
```

**e. 其他实用的插件**
- ctrlp 全局搜索
- vim-airline 状态栏
- YouCompleteMe 自动补全
- vim-gitgutter 基于git diff显示代码变动
- vim-javascript 更多js语法高亮

vim的插件相当多，按需装载即可，就不一一列举了。这里记录一个坑，vim-airline状态栏的箭头要正确显示，需要安装powerline-font，然后在iterm2中启用non-ASCII的字体

![iterm2中启用non-ASCII](http://upload-images.jianshu.io/upload_images/220182-9b7cace1916bbb86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## tmux配置

正如文章一开始的截图所以展示的，左下方窗口是shell 操作区，右下窗口是log 输出区域。其本质是用tmux 创建了3个panel ，上面1个用vim打开，下面左右各2个，左侧可以执行git 命令，右侧启动server 查看log

### 打开tmux
执行命令tmux，创建一个窗口
```
$ tmux
```
### 分屏
待开启了一个窗口之后，只需再按住 `ctrl-b` 和 `%` ，一个竖直窗格就出现了。另外，若要把屏幕沿水平方向分割，则只需要按下 `ctrl-b` 和 `"`。切换tmux之间的窗口只要按下 `ctrl-b` + 方向键。
### tmux 的快捷键前缀
刚刚所按住的 `ctrl-b` 是tmux的快捷键前缀，是用来区分tmux命令和其他shell命令的，为了方便按键，我们将修改这个前缀为`ctrl-a`
```
" ~/.tmux.conf 文件
unbind C-b
set -g prefix C-a
```
如果将ctrl键和caps lock键功能对调那就更方便了。按键习惯因人而异，开心就好。
### 在tmux中vim的高亮不对
在 `~/.vimrc` 中加以下配置即可
```
if exists('$TMUX')
  set term=screen-256color
endif
```
### 调整窗格布局
此时上面的窗格和下面2个窗格是等分的，将vim主窗口调整的更大一点，才更合理点。我们使用以下tmux命令，注意要按前缀`ctrl-a`，然后像vim一样按`:`
```
resize-pane [-DLRUZ] [-x width] [-y height] [-t target-pane] [adjustment]
```
比如窗格0高度偏移25
```
:resize-pane -t 0 -y 25
```
### 更多关于tmux
以上操作完成后，基本形成一个像截图所示的IDE了。关于tmux的window，panel，session的概念、其他的快捷操作等等，网上有许多教程可以参考，不在此赘述。
tmux非常强大，你甚至可以做结对编程：将tmux的session地址分享给他人，别人可以通过ssh接入这个session，进行协同操作。

# 总结
- 用tmux分屏，主屏打开vim，其他屏可以启动server查看log、执行git命令做版本管理等
- vim的配置文件是 `~/.vimrc`，用 [**vim**-**scripts**](http://www.baidu.com/link?url=1GWFahrLjB8Wq9-mv3AnnhznBCeOXsEKoSU61Ojcz2ncim-N8ISS2fiBe5DBYAhv) 配置
- 插件汇总在 [VimAwesome](http://vimawesome.com/) 网站上，可以用 **[Vundle.vim](https://github.com/VundleVim/Vundle.vim)** 管理
- 配置可以通过参考Github上众多的 [vim的配置](https://github.com/VundleVim/Vundle.vim/wiki/Examples) 来 **COPY-PASTE-MODIFY**，*所以我的vim配置也就没必要完整附上了*
- vim的操作训练可以用 [vim大冒险](http://vim-adventures.com/) 这个游戏来完成
