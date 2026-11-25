colors zenburn

set number relativenumber
set expandtab
set tabstop=4
set shiftwidth=4
"set ff=unix
set cursorcolumn
" set cursorline

syntax on
filetype plugin indent on
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType jav setlocal ts=4 sts=4 sw=4 expandtab

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-H> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>
:nnoremap <F2> gg"*yG''
:vnoremap <F3> "*y

set backspace=indent " I don't like not being able to backspace

" Bracketed paste mode: prevents È/É garbage characters around pasted text
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"

call plug#begin('~/.vim/plugged')
        " Make sure you use single quotes
        Plug 'christoomey/vim-tmux-navigator'
        Plug 'preservim/nerdtree'
        Plug 'tpope/vim-abolish'
        Plug 'tpope/vim-surround'
        Plug 'hashivim/vim-terraform'
        Plug 'Yggdroot/indentLine'
        Plug 'Vimjas/vim-python-pep8-indent'
        Plug 'chrisbra/csv.vim'
        Plug 'tmhedberg/SimpylFold'
        " Initialize plugin system
call plug#end()

" Indent Line
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_tab_guides = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

" Trim Whitespace
" https://vi.stackexchange.com/a/456
fun! TrimWhitespace()
        let l:save = winsaveview()
            keeppatterns %s/\s\+$//e
                call winrestview(l:save)
endfun
