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
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Shouldn't be needed anymore now that they fixed MPI's git
"let g:neobundle#types#git#default_protocol = 'git'
let g:neobundle#install_process_timeout = 1800

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'msanders/snipmate.vim'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'bling/vim-airline'
"NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'Valloric/YouCompleteMe', {'build' : {'unix' : 'python install.py'}}
"NeoBundle 'jcfaria/Vim-R-plugin'
NeoBundle 'jalvesaq/VimCom'
NeoBundle 'Shougo/vimproc.vim', {'build' : {'unix' : 'make -f make_unix.mak'}}
"NeoBundle 'Shougo/neosnippet.vim'
"NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'jgdavey/tslime.vim'
NeoBundle 'scrooloose/nerdtree'
" Wanted to use this with R but it is far too slow
NeoBundle 'scrooloose/syntastic'
" Totally bugged right now
"NeoBundle 'severin-lemaignan/vim-minimap'

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------

" Tslime settings
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" Syntastic settings for R.
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Disable autocheck on save
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [], 'passive_filetypes': [] }
"nnoremap <leader>sc :SyntasticCheck<CR>
"let g:syntastic_r_lint_styles = 'list(spacing.indentation.notabs, spacing.indentation.evenindent, spacing.spaceaftercomma, spacing.spacearoundinfix, spacing.spacearoundequals)'
let g:syntastic_enable_r_lintr_checker = 1
"let g:syntastic_r_checkers = 1
let g:syntastic_r_checkers = ['lintr']
" Disable the object checker because it executes code. Not safe for when I
" open untrested code
let g:syntastic_r_lintr_linters = "with_defaults(object_usage_linter = NULL, object_camel_case_linter = NULL)"

" Ctrl-p settings
"let g:ctrlp_user_command = 'find %s -type f ! -name "*.pdf" ! -name "*.'
" Search most recently used files first
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_max_files = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = {
			\ 'dir': '\v[\/]\.(git|hg|svn|cache)$',
			\ 'file': '\v\.(so|bed|fasta|gz|bz2|fastq|bam|wig|zip|rds|iso|jar|jpg|png|tif|pyc|pdf|doc|mp3)$',
			\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
			\ }
" This enables 'ag' but now the custom_ignore settings will not have any
" effect. They'll need to be added to a separate .ag-ignore-type file.
if executable("ag")
	let g:ctrlp_user_command = 'ag %s -l --follow --nocolor -g ""'
endif

" snipmate rebind to not stomp on YouCompleteMe
"let g:snips_trigger_key = '<C-j>'
let g:ycm_key_list_select_completion = []

colorscheme desert
"set cursorline


"----------------------------------------------------------------------------
" UI Settings

" Make status line (airline) display all of the time
set laststatus=2
set listchars=tab:>-,trail:?
let g:airline_powerline_fonts = 1

set wildmode=list:longest

" Fix odd backspacing problems
set backspace=indent,eol,start

set pastetoggle=<F12>

set spellfile=~/.vim/dict.add

" Insert time using <F5> in insert mode
map <f5>  O<C-R><C-R>=strftime("%Y-%m-%d (%A)")<CR><ESC>yypVr-o<CR><CR><ESC>ka- 
map <f6>  i*** <<C-R>=strftime("%Y-%m-%d %a")<CR>><ESC>o<CR>-  

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
set scrolloff=8

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

" Place the backup and swap files in another directory:
if isdirectory($HOME . '/.vim/tmp') == 0
	:silent !mkdir -p ~/.vim/tmp/undo ~/.vim/tmp/backup ~/.vim/tmp/swp >/dev/null 2>&1
endif
set undodir^=~/.vim/tmp/undo//
set backupdir^=~/.vim/tmp/backup//
set directory^=~/.vim/tmp/swp//

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

" Convenience functions for snippts. F12 to edit snippets for the current
" filetype
fun! OpenCurrentSnippets()
	let ft=&filetype
	"echom ft
	let ftfull="~/.vim/snippets/" . ft . ".snippets"
	echom ftfull
	"let g:snipfile=expand("~") . ".vim/snippets/" . ft . ".snippets"
	"echom g:snipfile
	execute "split " . ftfull
endfun

map <f12> :call OpenCurrentSnippets()<cr>
" Auto reload all snippets on snippet buffer save
autocmd BufWritePost *.snippets :call ReloadAllSnippets()
map <f9> :e ~/.vim/vimrc<cr>
" http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Various autocommands
autocmd FileType c,cpp set ts=4
autocmd FileType c,cpp,java,php,ruby,python,r autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd FileType xhtml,html,css set expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType r set expandtab tabstop=2 shiftwidth=2 softtabstop=2
" Markdown-related goodness
autocmd BufNewFile,BufRead *.md,*.mkdn,*.markdown :set filetype=markdown
autocmd FileType markdown set autoindent

" Highlight lines longer than 80 chars
hi ColorColumn ctermbg=235
call matchadd('ColorColumn', '\%81v', 100)

" Lines added by the Vim-R-plugin command :RpluginConfig (2014-Oct-30 14:47):
