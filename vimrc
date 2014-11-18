"NeoBundle Scripts-----------------------------
" Install with:
" curl \
" https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh \
" | sh
" or
" git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=/home/huska/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/huska/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'msanders/snipmate.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'bling/vim-airline'
NeoBundle 'Valloric/YouCompleteMe'
" Dev version of vim-r-plugin
NeoBundle 'jcfaria/Vim-R-plugin'
NeoBundle 'jalvesaq/VimCom'
"NeoBundle 'Shougo/neosnippet.vim'
"NeoBundle 'Shougo/neosnippet-snippets'
"NeoBundle 'tpope/vim-fugitive'
"NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
"NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Ctrl-p settings
let g:ctrlp_custom_ignore = {
			\ 'dir': '\v[\/]\.(git|hg|svn)$',
			\ 'file': '\v\.(so|bed|fasta|gz|bz2|fastq|bam|wig)$',
			\ 'link': 'some_bad_symbolic_links',
			\ }
let g:ctrlp_user_command = 'find %s -type f'

" snipmate rebind to not stomp on YouCompleteMe
"let g:snips_trigger_key = '<C-j>'
let g:ycm_key_list_select_completion = []

"set nocompatible
""filetype plugin indent on
"call pathogen#infect()
"call pathogen#runtime_append_all_bundles()
"filetype plugin indent on

"set t_Co=16

"syntax enable
"set background=light
"set background=dark
"colorscheme solarized
colorscheme desert

" Other handy things
"set number
"highlight LineNr      term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE 
autocmd FileType xhtml,html,css set expandtab tabstop=4 shiftwidth=4 softtabstop=4

autocmd FileType r set expandtab tabstop=2 shiftwidth=2 softtabstop=2

set listchars=tab:>-,trail:?,eol:$
"nmap <silent> <leader>s :set nolist!<CR>

" Custom status line... really just wanted to add Filetype
set laststatus=2
set ruler

set wildmode=list:longest

" Fix odd backspacing problems
set backspace=indent,eol,start

set pastetoggle=<F12>

set spellfile=~/.vim/dict.add

" Insert time using <F5> in insert mode
map <f5>  i<C-R>=strftime("%Y-%m-%d (%A)")<CR><ESC>yypVr-o<CR>-  
map <f6>  i*** <<C-R>=strftime("%Y-%m-%d %a")<CR>><ESC>o<CR>-  

"let vimrplugin_screenplugin = 1
"let vimrplugin_screenplugin = 0
let vimrplugin_assign = 0
let g:tex_flavor='latex'

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=0         "this is just what i use

" If using vim in xterm and having set mouse=a, you will notice mouse
" middle-click paste no longer seems to work. Instead use Shift+middle-click
" to paste X selection.
"set mouse=a

" ---------------------------------------------------------------------------
" New tips
" from http://items.sjbach.com/319/configuring-vim-right
set hidden
nnoremap ' `
nnoremap ` '
let mapleader = ","
let maplocalleader = "\\"
set history=1000
" allows % to switch between if/elsif/else/etc.
runtime macros/matchit.vim
" smarter search. Case sensitive only if capital in search
set ignorecase 
set smartcase
set scrolloff=3

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

syntax on
filetype on
filetype plugin on
filetype indent on
 
" Highlight search terms...
set hlsearch
set incsearch " ...dynamically as they are typed.

" Highlight matching braces with an underline
" http://design.liberta.co.za/articles/customizing-disabling-vim-matching-parenthesis-highlighting/
hi MatchParen cterm=underline,bold ctermbg=none ctermfg=none 
" current directory is always matching the
" content of the active window
"set autochdir
" --------------------------------------------------------------------------

" Remove trailing whitespace from certain files on save
" see
" http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
"
fun! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python,r autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Markdown-related goodness
autocmd BufNewFile,BufRead *.md,*.mkdn,*.markdown :set filetype=markdown
autocmd FileType markdown set autoindent

" Lines added by the Vim-R-plugin command :RpluginConfig (2014-Oct-30 14:47):
