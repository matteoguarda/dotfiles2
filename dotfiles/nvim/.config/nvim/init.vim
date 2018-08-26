" Plugins {{{

let mapleader=' '
let maplocalleader=' '

nnoremap <leader>pc :PlugClean!<cr>
nnoremap <leader>pu :PlugUpdate<cr>
nnoremap <leader>pi :PlugInstall<cr>

call plug#begin('~/.config/nvim/plugged')

Plug 'matteoguarda/wal.vim'
Plug 'junegunn/limelight.vim'
  nnoremap <leader>li :Limelight!!<cr>
Plug 'Yggdroot/indentLine'
  let g:indentLine_color_term = 17
  let g:indentLine_char = '▏'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
  augroup fzf_nost
    autocmd!
    autocmd FileType fzf set laststatus=0
    autocmd BufLeave <buffer> set laststatus=2
  augroup END
  nnoremap <leader>ff  :FZF<cr>
  nnoremap <leader>fbl :BLines<cr>
  nnoremap <leader>fll :Lines<cr>
Plug 'scrooloose/nerdtree'
  nnoremap <c-a> :NERDTreeToggle<cr>
  let g:NERDTreeDirArrowExpandable  = '+'
  let g:NERDTreeDirArrowCollapsible = '-'
  let g:NERDTreeStatusline          = ' '
  let g:NERDTreeMinimalUI           = 1
  let g:NERDTreeWinPos              = 'left'
  let g:NERDTreeWinSize             = 20
  augroup nerdtree_close
    autocmd!
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END

Plug 'terryma/vim-multiple-cursors'
  let g:multi_cursor_use_default_mapping = 0
  let g:multi_cursor_select_all_word_key = '<c-t>'
  let g:multi_cursor_next_key            = '<c-j>'
  let g:multi_cursor_prev_key            = '<c-k>'
  let g:multi_cursor_skip_key            = '<c-p>'
  let g:multi_cursor_quit_key            = '<esc>'
Plug 'terryma/vim-expand-region'
  xmap v <plug>(expand_region_expand)
  xmap <c-v> <plug>(expand_region_shrink)

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'rstacruz/vim-closer'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
  inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
Plug 'Shougo/neco-vim'
Plug 'zchee/deoplete-clang'
Plug 'wellle/tmux-complete.vim'
  let g:tmuxcomplete#trigger = ''
Plug 'w0rp/ale'
  let g:ale_echo_delay                       = 0
  let g:ale_lint_on_save                     = 0
  let g:ale_lint_on_text_changed             = 0
  let g:ale_lint_on_enter                    = 0
  let g:ale_sign_error                       = '> '
  let g:ale_sign_warning                     = '! '
  augroup ale_disable_on_startup
    autocmd!
    autocmd BufReadPre * ALEDisable
  augroup END
  nnoremap <leader>aa :ALEEnable<cr>
  nnoremap <leader>af :ALEDisable<cr>
  nmap <silent> <c-q> <plug>(ale_previous_wrap)
  nmap <silent> <c-e> <plug>(ale_next_wrap)

Plug 'mattn/emmet-vim'
  let g:user_emmet_leader_key = '<c-d>'
Plug 'junegunn/vim-easy-align'
  xmap ga <plug>(EasyAlign)
  nmap ga <plug>(EasyAlign)

Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 200
Plug 'yuttie/comfortable-motion.vim'
  let g:comfortable_motion_no_default_key_mappings = 1
  nnoremap <silent> J                 :call comfortable_motion#flick(55)<cr>
  nnoremap <silent> K                 :call comfortable_motion#flick(-55)<cr>
  noremap  <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<cr>
  noremap  <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<cr>
Plug 'lambdalisue/vim-manpager'
Plug 'rhysd/open-pdf.vim'

call plug#end()

" }}}

" Options {{{

set encoding=utf-8
scriptencoding utf-8

syntax on
filetype on
filetype plugin indent on

set mouse=a
set nonumber
set nocursorline
set wrap
set shiftround
set noshowmode
set noruler
set laststatus=2
set statusline=%#BarraVuota# 
set noshowcmd
set shortmess+=csW
set t_Co=256
set notermguicolors
colorscheme wal
set fillchars=fold:\ 
set foldlevelstart=0
set colorcolumn=0
set hlsearch
set incsearch
set ignorecase
set smartcase
set hidden
set history=10000
set backupdir=~/.config/nvim/tmp,~/.vim/tmp,.
set directory=~/.config/nvim/tmp,~/.vim/tmp,.
set backspace=indent,eol,start
set clipboard=unnamedplus
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent

" }}}

" Tab line {{{

" This is code is almost 100% from :help setting-tabline, I've modified some
" things.
" I've removed the X on the right side of the tab line and made use of
" fnamemodify to get the only the name of the file, not the full path.
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  " Remove close from s to don't display the close button.
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  " Use of fnamemodify to get only the name of the file, not its full or
  " relative path.
  return fnamemodify(bufname(buflist[winnr - 1]), ':t')
endfunction

set tabline=%!MyTabLine()

" }}}

" Mappings {{{

nnoremap <leader><leader> /
nnoremap <silent> <leader>mo :nohlsearch<cr>
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <silent> <leader>rr :source $MYVIMRC<cr>
nnoremap <silent> <leader>n  :set number! cursorline!<cr>
nnoremap <silent> <c-h> :tabprevious<cr>
nnoremap <silent> <c-l> :tabnext<cr>
nnoremap <silent> <c-n> :cnext<cr>zz
nnoremap <silent> <c-m> :cprevious<cr>zz
nnoremap H 0
nnoremap L $
nnoremap , :
nnoremap è .
nnoremap <silent> <leader>,  :call <SID>ToggleFinalDot()<cr>
nnoremap <silent> <leader>w  :call <SID>ToggleTextWidth()<cr>
nnoremap <silent> <leader>co :call <SID>ToggleConceal()<cr>
nnoremap <silent> <leader>cc :call <SID>ColorColumnToggle()<cr>
nnoremap <silent> <leader>q  :call <SID>QuickfixToggle()<cr>
nnoremap <silent> <leader>g  :set operatorfunc=<SID>GrepOperator<cr>g@
nnoremap <leader>.  :<bs>

xnoremap , :
xnoremap H 0
xnoremap L $
xnoremap <silent> <leader>g  :<c-u>call <SID>GrepOperator(visualmode())<cr>

cnoremap W w
cnoremap Q q

" }}}

" Auto commands {{{

" Use marker method of folding for any Vimscript file.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

" Functions {{{

" Toggle the final dot in the end of a sentence.
function! s:ToggleFinalDot()
  let sunreg = @@

  :normal $vy
  if @@ ==# '.'
    :normal $x
  else
    :execute "normal $a.\e"
  endif

  let @@ = sunreg
endfunction

" Toggle the text width.
function! s:ToggleTextWidth()
  if &textwidth
    setlocal textwidth=0
  else
    setlocal textwidth=79
  endif
endfunction

" Toggle the conceal level.
function! s:ToggleConceal()
  if &conceallevel
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction

" Toggle the colorcolumn.
function! s:ColorColumnToggle()
  if &colorcolumn
    setlocal colorcolumn=0
  else
    setlocal colorcolumn=79
  endif
endfunction

" Toggle the quickfix window.
let g:quickfix_is_open = 0

function! s:QuickfixToggle()
  if g:quickfix_is_open
    cclose
    let g:quickfix_is_open = 0
    execute g:quickfix_return_to_window . 'wincmd w'
  else
    let g:quickfix_return_to_window = winnr()
    copen 8
    let g:quickfix_is_open = 1
  endif
endfunction

" Grep operator.
function! s:GrepOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[y`]
  else
    return
  endif

  silent execute 'grep! -R ' . shellescape(@@) . ' .'
  copen 8

  let @@ = saved_unnamed_register
endfunction

" }}}
