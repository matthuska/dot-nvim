""------------------------------------------------------------------------------
"" Settings for neovim
""------------------------------------------------------------------------------
"" Package management with vim-plug
"" Upgrade vim-plug:      :PlugUpgrade
"" Upgrade all packages:  :PlugUpdate
"" 
"" Install with:
"" curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
""    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
""
"" Autoinstall if not already installed:
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif    

call plug#begin()
Plug 'msanders/snipmate.vim'
Plug 'kien/ctrlp.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'bling/vim-airline'
Plug 'Valloric/YouCompleteMe', {'build' : {'unix' : 'git submodule update --init --recursive && python install.py'}}
"Plug 'jcfaria/Vim-R-plugin'
Plug 'jalvesaq/VimCom'
Plug 'Shougo/vimproc.vim', {'build' : {'unix' : 'make -f make_unix.mak'}}
Plug 'tpope/vim-fugitive'
Plug 'jgdavey/tslime.vim'
Plug 'scrooloose/nerdtree'
"Plug 'scrooloose/syntastic'
Plug 'neomake/neomake'
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'godlygeek/tabular'
Plug 'dpelle/vim-LanguageTool'
" Show changed lines in the gutter using git
Plug 'airblade/vim-gitgutter'
call plug#end()

"------------------------------------------------------------------------------
" Misc
syntax on
filetype on

"------------------------------------------------------------------------------
" Plugin setup

" Tslime
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" Syntastic (R)
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

" Ctrl-p
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

" Vim-R-Plugin
let vimrplugin_assign = 0

" Snippets
" Convenience functions for snippts. F12 to edit snippets for the current
" filetype
fun! OpenCurrentSnippets()
	let ft=&filetype
	"echom ft
	let ftfull="~/.config/nvim/snippets/" . ft . ".snippets"
	echom ftfull
	execute "vsplit " . ftfull
endfun

map <f12> :call OpenCurrentSnippets()<cr>
" Auto reload all snippets on snippet buffer save
autocmd BufWritePost *.snippets :call ReloadAllSnippets()

" LatexBox
let g:tex_flavor='latex'
let g:LatexBox_quickfix=1
let g:LatexBox_latexmk_async=1
let g:LatexBox_autojump=1
let g:LatexBox_show_warnings=0

" vim-LanguageTool grammar checker
let g:languagetool_jar='$HOME/opt/LanguageTool-3.5/languagetool-commandline.jar'

"------------------------------------------------------------------------------
" UI Settings

colorscheme desert

" Make status line (airline) display all of the time
set laststatus=2
set listchars=tab:>-,trail:?
let g:airline_powerline_fonts = 1

" Highlight lines longer than 80 chars
hi ColorColumn ctermbg=235
call matchadd('ColorColumn', '\%81v', 100)

"----------------------------------------------------------------------------
" Other Settings

set wildmode=list:longest

" Fix odd backspacing problems
set backspace=indent,eol,start

" Check current and previous directory for a custom dictionary file, else use
" the common custom dictionary
" Note: After manually editing dictionary, open it and run ":mkspell! %" to
" rebuild .spl file
function! SetSpellfile()
	" Set the default location
	setlocal spellfile=~/sync/homedir/vim/dict.en.utf-8.add

	if filereadable("./dict.en.utf-8.add")
		setlocal spellfile=./dict.en.utf-8.add
	elseif filereadable("../dict.en.utf-8.add")
		setlocal spellfile=../dict.en.utf-8.add
	elseif !filereadable($HOME."/sync/homedir/vim/dict.en.utf-8.add")
		silent !mkdir ~/sync/homedir/vim/ > /dev/null 2>&1
		silent !touch ~/sync/homedir/vim/dict.en.utf-8.add
	endif

endfunction
autocmd BufNewFile,BufRead * :call SetSpellfile()


" Insert time using <F5> in insert mode
map <f5>  O<C-R><C-R>=strftime("%Y-%m-%d (%A)")<CR><ESC>yypVr-o<CR><CR><ESC>ka- 
map <f6>  i*** <<C-R>=strftime("%Y-%m-%d %a")<CR>><ESC>o<CR>-  

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=0         "this is just what i use

" New tips
" from http://items.sjbach.com/319/configuring-vim-right
set hidden
nnoremap ' `
nnoremap ` '
let mapleader = ","
let maplocalleader = "\\"
set history=1000

" ??
nnoremap <leader>w g<C-g>
vnoremap <leader>w g<C-g>

" allows % to switch between if/elsif/else/etc.
runtime macros/matchit.vim

" smarter search. Case sensitive only if capital in search
set ignorecase 
set smartcase
set scrolloff=8

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Highlight search terms...
set hlsearch
set incsearch " ...dynamically as they are typed.

" Highlight matching braces with an underline
" http://design.liberta.co.za/articles/customizing-disabling-vim-matching-parenthesis-highlighting/
hi MatchParen cterm=underline,bold ctermbg=none ctermfg=none 
hi SpellBad cterm=underline,bold ctermbg=none ctermfg=none 
hi Search cterm=bold ctermbg=DarkGrey ctermfg=none 

" current directory is always matching the
" content of the active window
"set autochdir

" Place the backup and swap files in another directory:
if isdirectory($HOME . '/.cache/nvim/tmp') == 0
	:silent !mkdir -p ~/.cache/nvim/tmp/undo ~/.cache/nvim/tmp/backup ~/.cache/nvim/tmp/swp >/dev/null 2>&1
endif
set undodir^=~/.cache/nvim/tmp/undo//
set backupdir^=~/.cache/nvim/tmp/backup//
set directory^=~/.cache/nvim/tmp/swp//

" Convenience functions for editing vimrc. Easy open (F9) and auto reload on
" save.
map <f9> :e ~/.config/nvim/init.vim<cr>
" http://superuser.com/questions/132029/how-do-you-reload-your-vimrc-file-without-restarting-vim
augroup myvimrc
    au!
    " Reload airline (twice) colors so that the status line isn't blanked out
    au BufWritePost init.vim,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif | AirlineRefresh | AirlineRefresh
augroup END

" --------------------------------------------------------------------------
" Filetype specific settings

" Remove trailing whitespace from certain files on save
" http://stackoverflow.com/questions/356126/how-can-you-automatically-remove-trailing-whitespace-in-vim
fun! <SID>StripTrailingWhitespaces()
	let l = line(".")
	let c = col(".")
	%s/\s\+$//e
	call cursor(l, c)
endfun

" Various autocommands
autocmd FileType c,cpp set ts=4
autocmd FileType c,cpp,java,php,ruby,python,r autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd FileType xhtml,html,css set expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType r set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.md,*.mkdn,*.markdown :set filetype=markdown
autocmd FileType markdown set autoindent spell
autocmd FileType tex set spell
" Useful for thesis writing. Check parent dir for Makefile.
autocmd Filetype tex let &makeprg = 'if [ -f Makefile ]; then make; else make -C ..; fi'
