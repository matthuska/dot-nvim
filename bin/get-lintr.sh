#!/bin/sh
# Download the R lintr vim syntax checker for synatastic. This should be added
# as a post-install hook for NeoBundle.

curl https://raw.githubusercontent.com/jimhester/lintr/master/inst/syntastic/lintr.vim \
	> ~/.vim/bundle/syntastic/syntax_checkers/r/lintr.vim
