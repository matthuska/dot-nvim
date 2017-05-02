if exists("disable_beamer_ftplugin")
  finish
endif

autocmd BufNewFile,BufRead *.tex if getline(1) =~ 'beamer' | set ft=beamer | endif

