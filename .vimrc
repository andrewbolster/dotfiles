"
" Even though with vim_runtime you're supposed to add your own customizations 
" in ~/.vim_runtime/my_configs.vim; because that's a git-repo, yadm doesn't 
" like it, so i'm doing my customisations here

set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim
try
  source ~/.vim_runtime/my_configs.vim
catch
endtry

" Bolsters customisations
set number
set mouse=a
