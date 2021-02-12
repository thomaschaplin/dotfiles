" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

    " Intellisense
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Nerd Tree
    Plug 'scrooloose/nerdtree'
    " Ctrl P
    " Plug 'ctrlpvim/ctrlp.vim'
    " Themes
    Plug 'joshdick/onedark.vim'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " Auto Pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " GIT
    Plug 'tpope/vim-fugitive'
    " Status Line
    Plug 'vim-airline/vim-airline'
    " FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'airblade/vim-rooter'
   " Start Screen
    " Plug 'mhinz/vim-startify'
    " Snippets
    Plug 'honza/vim-snippets'
    " Gutter
    Plug 'airblade/vim-gitgutter'

   call plug#end()
