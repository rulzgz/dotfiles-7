" TODO: make all the paths in the script be read from a configuration file
" that is modified by the bootstrap script
let basedir = "$HOME/dotfiles/vim/"

" Leave no backwards meh from vi
set nocompatible

" Basic styling options
syntax enable
filetype plugin on
set number
set nowrap
set hidden

let g:netrw_liststyle = 3
let g:netrw_banner = 0
if !exists(":Drawer")
  function s:PrjDraw()
    let g:netrw_winsize = 25
    :Vexplore
    let g:netrw_altv = 1
    let g:netrw_browse_split = 4
  endfunction
  
  command Drawer call <SID>PrjDraw()
endif

" VIM-GO
" Initialize vim-go shit
call plug#begin()
Plug 'fatih/vim-go'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'SirVer/ultisnips'
Plug 'chriskempson/base16-vim'
call plug#end()

" Write the file automatically when running a command such as GoBuild or make
set autowrite

" Make all go's errors a quickfix list
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"

" Lets just complete me and not add some stupid buffers yeah?
set completeopt=menu

" GO SYNTAX
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1


" INDENTATION
set ts=4 sts=4 sw=4 expandtab
set autoindent

" Indentation based on filetype
if has("autocmd")
  exec 'source' basedir . "indentation.vim"
endif


" SEARCHING
set smartcase
set hlsearch
set incsearch


" REMAPS
" Remap ; and : for easy command mode shenanigans
nnoremap ; :
nnoremap : ;

" <C-h|j|k|l> to move between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

noremap <C-n> :cnext<CR>
noremap <C-m> :cprevious<CR>
noremap ,q :cclose<CR>


" PATH
set path=.,,**,
" `gf` opens file under cursor in a new vertical split
nnoremap gf :vertical wincmd f<CR>

" AUTOCMD REQUIRED STUFF
if has("autocmd")
  " vim-go specific configuration
  exec 'source' basedir . "vim-go.vim"

  " Change path according to filetype
  exec 'source' basedir . "path.vim"
endif

" Display tab-completion matches in a cool menu thingy
set wildmenu

" Fold by syntax
"set fdm=syntax

" Remap <Space> to toggle folds
nnoremap <Space> za

" Uncomment this to use space to fold under cursor till the end instead of one
" level
"nnoremap <Space> zM:echom foldlevel(line('.'))<CR>

set foldlevel=0

" This requires ctags installed
" Map the command 'MakeTags' to generate the tags file for the project
" ^]  - jump to tag
" g^] - jump to ambiguous tag
" ^t  - jump back to tag stack
command! MakeTags !ctags -R .

" Autocomplete documentation is present in |ins-completion|
" Good little things to remember:
" ^n         - display all autocomplete options and scroll down the options list
"              (^p to go back in the options)
" ^x[option] - autocomplete options are based on selective things, such as:
"              ^n - complete from this file only
"              ^f - complete by filenames only
"              ^j - complete by tags

" Snippets
execute 'nnoremap' ',go' ":-1read " . basedir . "snippets/go/skele.go<CR>A"
execute 'nnoremap' ',iferr' ":-1read " . basedir . "snippets/go/iferr.go<CR>jA"
execute 'nnoremap' ',sh' ":-1read " . basedir . "snippets/skele.sh<CR>2jA"
execute 'nnoremap' ',py' ":-1read " . basedir . "snippets/skele.py<CR>4jA"

" Powerline
set rtp+=/usr/lib/python3.6/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
