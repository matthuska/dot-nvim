" Java specific settings
set makeprg=ant\ -emacs\ -find\ 'build.xml' 

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Highlight lines that are too long
set textwidth=80
au BufNewFile,BufRead *.java exec 'match Todo /\%>' .  &textwidth . 'v.\+/' 
