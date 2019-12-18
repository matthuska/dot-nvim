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
  "" Only works if curl is installed
  if executable('curl')
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
  endif
endif    

call plug#begin()
Plug 'mhinz/vim-startify'
Plug 'msanders/snipmate.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'bling/vim-airline'
Plug 'jalvesaq/VimCom'
Plug 'Shougo/vimproc.vim', {'build' : {'unix' : 'make -f make_unix.mak'}}
Plug 'tpope/vim-fugitive'
Plug 'jgdavey/tslime.vim'
Plug 'scrooloose/nerdtree'
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'godlygeek/tabular'
Plug 'dpelle/vim-LanguageTool'
" Show changed lines in the gutter using git
Plug 'airblade/vim-gitgutter'
" Simple latex folding
Plug 'matze/vim-tex-fold'
" Sublime Text-style minimap with :Minimap
Plug 'severin-lemaignan/vim-minimap'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-unimpaired'

if exists("g:loaded_python_provider")
  Plug 'davidhalter/jedi-vim'
endif
" Not easy to get going with python
Plug 'majutsushi/tagbar'
"
" Plugins to look at later
" Plug 'idanarye/vim-vebugger'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'Valloric/YouCompleteMe', {'build' : {'unix' : 'git submodule update --init --recursive && python install.py'}}

" Color scheme
Plug 'mhinz/vim-janah'

call plug#end()

"------------------------------------------------------------------------------
" Misc (http://vim.1045645.n5.nabble.com/Autocommand-vs-ftplugin-td5723140.html)
filetype on
syntax on

"------------------------------------------------------------------------------
" Plugin setup

" vim-janah: Syntax coloring
autocmd ColorScheme janah highlight Normal ctermbg=235
colorscheme janah

" Tslime
vmap <C-c><C-c> <Plug>SendSelectionToTmux
nmap <C-c><C-c> <Plug>NormalModeSendToTmux
nmap <C-c>r <Plug>SetTmuxVars

" fugitive
command! -nargs=+ Ggr execute 'silent Ggrep!' <q-args> | cw | redraw!
" git grep the word under the cursor
nnoremap <C-g> :Ggr <cword><CR>

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

" Settings for Tagbar symbol browser
let g:tagbar_left=1

"" snipmate rebind to not stomp on YouCompleteMe
""let g:snips_trigger_key = '<C-j>'
"let g:ycm_key_list_select_completion = []
"let g:loaded_youcompleteme = 1

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
let g:languagetool_jar='$HOME/opt/LanguageTool/languagetool-commandline.jar'
let g:languagetool_disable_rules='DASH_RULE,WHITESPACE_RULE,EN_QUOTES,CURRENCY,EN_UNPAIRED_BRACKETS,COMMA_PARENTHESIS_WHITESPACE'

"------------------------------------------------------------------------------
" UI Settings

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
	setlocal spellfile=~/.cache/nvim/dict.en.utf-8.add

	if filereadable("./dict.en.utf-8.add")
		setlocal spellfile=./dict.en.utf-8.add
	elseif filereadable("../dict.en.utf-8.add")
		setlocal spellfile=../dict.en.utf-8.add
	elseif !filereadable($HOME."/.cache/nvim/dict.en.utf-8.add")
		silent !mkdir -p ~/.cache/nvim/ > /dev/null 2>&1
		silent !touch ~/.cache/nvim/dict.en.utf-8.add
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
highlight MatchParen cterm=underline,bold ctermbg=none ctermfg=none 
highlight SpellBad cterm=underline,bold ctermbg=none ctermfg=none 
highlight Search cterm=bold ctermbg=DarkGrey ctermfg=none 

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

" Hide gutters
"let g:ale_lint_on_enter=0
"let g:ale_enabled = 1
map <f4> :ALEToggleBuffer<cr>
map <f7> :GitGutterToggle<cr>
map <f8> :TagbarToggle<cr>
" Toggle hide commented lines (doesn't work properly)
"map <f2> :hi! link Comment Comment

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
"autocmd FileType c,cpp,java,php,ruby,python,r,snakemake autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd FileType xhtml,html,css set expandtab tabstop=8 shiftwidth=4 softtabstop=4
autocmd FileType r autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
autocmd FileType r set expandtab tabstop=2 shiftwidth=2 softtabstop=2
autocmd BufNewFile,BufRead *.md,*.mkdn,*.markdown :set filetype=markdown
autocmd FileType markdown set autoindent spell
autocmd FileType tex set spell
" Useful for thesis writing. Check parent dir for Makefile.
autocmd Filetype tex let &makeprg = 'if [ -f Makefile ]; then make; else make -C ..; fi'
" yaml files were being indented with 8 spaces, should be 2
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType snakemake setlocal textwidth=0 wrapmargin=0 ts=4 sts=4 sw=4 expandtab
"autocmd FileType python setlocal textwidth=88 expandtab tabstop=8 shiftwidth=4 softtabstop=4

" Recognize Snakemake files
au BufNewFile,BufRead Snakefile set syntax=snakemake
au BufNewFile,BufRead *.smk set syntax=snakemake

" Crazy settings for python indentation using tabs
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" " --- ALE ---
" > names(default_linters) for lintr
" absolute_paths_linter
" assignment_linter
" camel_case_linter
" closed_curly_linter
" commas_linter
" commented_code_linter
" infix_spaces_linter
" line_length_linter
" multiple_dots_linter
" no_tab_linter
" object_length_linter
" object_usage_linter
" open_curly_linter
" single_quotes_linter
" spaces_inside_linter
" spaces_left_parentheses_linter
" trailing_blank_lines_linter
" trailing_whitespace_linter
let g:ale_r_lintr_options = 'with_defaults(line_length_linter = line_length_linter(120), multiple_dots_linter = NULL, commas_linter = NULL)'
"let g:ale_r_lintr_options = 'with_defaults(no_tab_linter = NULL)'
" "let g:ale_virtualenv_dir_names = []
" let g:ale_pattern_options = {'\.R$': {'ale_enabled': 1}}
" let g:ale_sign_column_always = 1
" "let g:ale_command_wrapper = 'conda activate py2dev && '
"
let r_indent_align_args = 0
"
" tagbar for R
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
\ }

augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
